extends Area2D

var to_up = false
var to_down = false
var on_top = true
var on_bottom = false
var aux_z_index = 0

export var speed = 400
export var invencible = false

var limit_top_position = 0
var limit_bottom_position = 0
var on_collision_with_enemy = -1
var died = false

# Called when the node enters the scene tree for the first time.
func _ready():
	limit_top_position = get_parent().get_node("TopLimit").position
	limit_bottom_position = get_parent().get_node("BottomLimit").position
	
	if not invencible:
		add_to_group("player")
		var _area_entered_connection = connect("area_entered", self, "_on_area_entered")
		var _show_game_over_connection = Events.connect("show_game_over", self, "_on_show_game_over")
		var _resume_game_connection = Events.connect("resume_game", self, "_on_resume_game")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	detect_collision()

func move(delta):
	if to_up and not on_top:
		self.translate(Vector2(0, -speed * delta))
		if self.position.y <= limit_top_position.y:
			to_up = false
			on_bottom = false
			on_top = true
	elif to_down and not on_bottom:
		self.translate(Vector2(0, speed * delta))
		if self.position.y >= limit_bottom_position.y:
			to_down = false
			on_top = false
			on_bottom = true

func _on_SwipeDetector_swiped(gesture):
	if not died:
		on_bottom = false
		on_top = false
	
		if gesture.get_direction() == "up":
			to_up = true
			to_down = false
		elif gesture.get_direction() == "down":
			to_up = false
			to_down = true

# Instructions occurrs when start collision
func _on_area_entered(other):
	if other.is_in_group("enemy"):
		on_collision_with_enemy = other.from_spawn

func detect_collision():
	if on_collision_with_enemy in [0, 1, 6, 7] and (
		on_top or on_bottom
	):
		Events.emit_signal("player_damage", "on_sidewalk")
		on_collision_with_enemy = -1
	elif on_collision_with_enemy in [2, 5] and (
		to_up or to_down
	):
		Events.emit_signal("player_damage", "on_street")
		on_collision_with_enemy = -1

func _on_show_game_over():
	died = true

func _on_resume_game():
	died = false

func _on_DistanceScoreTimer_timeout():
	Events.emit_signal("count_point", 1)
