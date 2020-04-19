extends Area2D


signal final_position(position)


const FLICK_LIMIT = 31
const SIDEWALK_SPAWN_POSITIONS = [0, 6]
const STREET_SPAWN_POSITIONS = [2, 5]


export var speed = 400
export var invencible = false


var to_up = false
var to_down = false
var on_top = true
var on_bottom = false
var died = false
var is_flicking = false
var speed_reduced = false

var limit_top_position = 0
var limit_bottom_position = 0
var on_collision_with_enemy = -1
var flick_counter = 0

var effect_to_use = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_parent().z_index = -1
	limit_top_position = get_parent().get_node("TopLimit").position
	limit_bottom_position = get_parent().get_node("BottomLimit").position
	
	add_to_group("player")
	do_connections()


func do_connections():
	var _area_entered_connection = connect(
		"area_entered", self, "_on_area_entered"
	)
	var _show_game_over_connection = Events.connect(
		"show_game_over",
		self,
		"_on_show_game_over"
	)
	var _resume_game_connection = Events.connect(
		"resume_game",
		self,
		"_on_resume_game"
	)
	var _player_invencibility_connect = Events.connect(
		"player_invencibility",
		self,
		"_on_player_invencibility"
	)
	var _player_magnet_connect = Events.connect(
		"player_magnet",
		self,
		"_on_player_magnet"
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not died:
		move(delta)
		detect_collision()
		flick_verification()


func move(delta):
	if to_up and not on_top:
		self.translate(Vector2(0, -speed * delta))
		if self.position.y <= limit_top_position.y:
			to_up = false
			on_bottom = false
			on_top = true
			emit_signal("final_position", "top")
			self.get_parent().z_index = -1
	elif to_down and not on_bottom:
		self.translate(Vector2(0, speed * delta))
		if self.position.y >= limit_bottom_position.y:
			to_down = false
			on_top = false
			on_bottom = true
			emit_signal("final_position", "bottom")
			self.get_parent().z_index = 0
	self.position.y = clamp(
		self.position.y,
		limit_top_position.y,
		limit_bottom_position.y
	)
	Events.emit_signal("player_position_updated", self.global_position)


func detect_collision():
	if not invencible:
		if on_collision_with_enemy in SIDEWALK_SPAWN_POSITIONS and (
			on_top or on_bottom
		):
			Events.emit_signal("player_damage", "on_sidewalk")
			is_flicking = true
			on_collision_with_enemy = -1
		elif on_collision_with_enemy in STREET_SPAWN_POSITIONS and (
			to_up or to_down
		):
			Events.emit_signal("player_damage", "on_street")
			is_flicking = true
			on_collision_with_enemy = -1


func flick_verification():
	if is_flicking:
		if flick_counter < FLICK_LIMIT:
			if flick_counter % 2 == 0:
				self.hide()
				flick_counter = flick_counter + 1
			else:
				self.show()
				flick_counter = flick_counter + 1
		else:
			self.show()
			is_flicking = false
			flick_counter = 0


# Instructions occurrs when start collision
func _on_area_entered(other):
	if(
		other.is_in_group("enemy")
		and not invencible
		and not other.is_flicking
		and not is_flicking
	):
		on_collision_with_enemy = other.get_from_spawn()


func _on_show_game_over():
	died = true
	invencible = false
	speed_reduced = false


func _on_resume_game():
	died = false


func _on_DistanceScoreTimer_timeout():
	Events.emit_signal("count_point", 1)


func _on_player_invencibility(state):
	invencible = state


func _on_player_magnet(state):
	self.get_node("MagnetArea/Particles2D").emitting = state
	self.get_node("MagnetArea/CollisionShape2D").disabled = not state


func _on_PlayerController_move_to(direction):
	match direction:
		"up": 
			if not on_top:
				to_up = true
				to_down = false
		"down": 
			if not on_bottom:
				to_up = false
				to_down = true
