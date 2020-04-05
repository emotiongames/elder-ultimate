extends Area2D

const FLICK_LIMIT = 31
const SIDEWALK_SPAWN_POSITIONS = [0, 1, 6, 7]
const STREET_SPAWN_POSITIONS = [2, 5]

export var speed = 400
export var invencible = false

var to_up = false
var to_down = false
var on_top = true
var on_bottom = false
var died = false
var is_flicking = false

var limit_top_position = 0
var limit_bottom_position = 0
var on_collision_with_enemy = -1
var flick_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_parent().z_index = -1
	limit_top_position = get_parent().get_node("TopLimit").position
	limit_bottom_position = get_parent().get_node("BottomLimit").position
	
	if not invencible:
		add_to_group("player")
		var _area_entered_connection = connect("area_entered", self, "_on_area_entered")
		var _area_exited_connection = connect("area_exited", self, "_on_area_exited")
		var _show_game_over_connection = Events.connect("show_game_over", self, "_on_show_game_over")
		var _resume_game_connection = Events.connect("resume_game", self, "_on_resume_game")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	detect_collision()
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

func move(delta):
	if to_up and not on_top:
		self.translate(Vector2(0, -speed * delta))
		if self.position.y <= limit_top_position.y:
			to_up = false
			on_bottom = false
			on_top = true
			self.get_parent().z_index = -1
	elif to_down and not on_bottom:
		self.translate(Vector2(0, speed * delta))
		if self.position.y >= limit_bottom_position.y:
			to_down = false
			on_top = false
			on_bottom = true
			self.get_parent().z_index = 0

func detect_collision():
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

func _on_SwipeDetector_swiped(gesture):
	if not died:
		if gesture.get_direction() == "up" and not on_top:
			to_up = true
			to_down = false
		elif gesture.get_direction() == "down" and not on_bottom:
			to_up = false
			to_down = true

# Instructions occurrs when start collision
func _on_area_entered(other):
	if other.is_in_group("enemy"):
		on_collision_with_enemy = other.from_spawn

func _on_area_exited(other):
	if other.is_in_group("enemy"):
		on_collision_with_enemy = -1

func _on_show_game_over():
	died = true

func _on_resume_game():
	died = false

func _on_DistanceScoreTimer_timeout():
	Events.emit_signal("count_point", 1)
