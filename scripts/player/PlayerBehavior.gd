extends Area2D


signal final_position(position)


const FLICK_LIMIT = 31
const SIDEWALK_SPAWN_POSITIONS = [0, 6]
const STREET_SPAWN_POSITIONS = [2, 5]


export var speed = 10
export var invencible = false


var to_up = false
var to_down = false
var on_top = true
var on_bottom = false
var died = false
var is_flicking = false
var speed_reduced = false

var limit_top = 0
var limit_bottom = 0
var flick_counter = 0

var effect_to_use = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_parent().z_index = -1
	limit_top = get_parent().get_node("TopLimit")
	limit_bottom = get_parent().get_node("BottomLimit")
	
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
		flick_verification()


func move(delta):
	if to_up and not on_top:
		#self.translate(Vector2(0, -speed * delta))
		#self.scale = lerp(self.scale, Vector2(0.6, 0.6), 10 * delta)
		#self.transform = lerp(self.transform, limit_top.transform, 10 * delta)
		self.transform = self.transform.interpolate_with(limit_top.transform, 10 * delta)
		#print(1)
		
	elif to_down and not on_bottom:
		#self.translate(Vector2(0, speed * delta))
		#self.scale = lerp(self.scale, Vector2(1.7, 1.7), 10 * delta)
		#self.transform = lerp(self.transform, limit_bottom.transform, 10 * delta)
		self.transform = self.transform.interpolate_with(limit_bottom.transform, 10 * delta)
		
	#print(self.get_parent().z_index)
#	self.position.y = clamp(
#		self.position.y,
#		limit_top.position.y,
#		limit_bottom.position.y
#	)
	self.scale.y = clamp(
		self.scale.y,
		limit_top.scale.y,
		limit_bottom.scale.y
	)
	self.scale.x = clamp(
		self.scale.x,
		limit_top.scale.x,
		limit_bottom.scale.x
	)
	Events.emit_signal("player_position_updated", self.global_position)
	print(self.position.y)
	print(limit_top.position.y)
	print(limit_bottom.position.y)
	if self.position.y <= limit_top.position.y:
		to_up = false
		on_bottom = false
		on_top = true
		emit_signal("final_position", "top")
		self.get_parent().z_index = -1
	elif self.position.y >= limit_bottom.position.y:
		to_down = false
		on_top = false
		on_bottom = true
		emit_signal("final_position", "bottom")
		self.get_parent().z_index = 0


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
		var area_spawned_from = other.get_from_spawn()
		detect_collision(area_spawned_from)


func detect_collision(area_from):
	if not invencible:
		if area_from in SIDEWALK_SPAWN_POSITIONS:
			Events.emit_signal("player_damage", "on_sidewalk")
			is_flicking = true
		elif area_from in STREET_SPAWN_POSITIONS and (
			to_up or to_down
		):
			Events.emit_signal("player_damage", "on_street")
			is_flicking = true


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
				on_bottom = false
		"down": 
			if not on_bottom:
				to_up = false
				to_down = true
				on_top = false
