class_name EnemyBase
extends Area2D


const FLICK_LIMIT = 31


var speed = 0 setget set_speed, get_speed
var speed_factor = 0 setget set_speed_factor, get_speed_factor
# -1 to left / 1 to right
var direction = 0 setget set_direction, get_direction
var from_spawn = -1 setget set_from_spawn, get_from_spawn
var label = "" setget set_label, get_label

var is_flicking = false

var spawn_position = Vector2(0, 0)
var bias_position = Vector2(0, 0)

var player_collision = -1
var flick_counter = 0
var screen_width = 0
var enemy_width = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_width = ProjectSettings.get_setting("display/window/size/width")
	enemy_width = self.get_child(0).texture.get_width()
	spawn_position = self.position
	bias_position.x = screen_width + enemy_width + spawn_position.x
	
	add_to_group("enemy")
	do_connections()


func do_connections():
	var _show_game_over_connection = Events.connect(
		"show_game_over",
		self,
		"_on_show_game_over"
	)
	var _area_entered_connection =  connect(
		"area_entered",
		self,
		"_on_area_entered"
	)
	var _scroll_speed_updated_connect = Events.connect(
		"scroll_speed_updated",
		self,
		"_on_scroll_speed_updated"
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fick_verification()
	move(delta)


func move(delta):
	self.translate(Vector2((speed * delta) * direction, 0))


func fick_verification():
	if is_flicking:
		if flick_counter < FLICK_LIMIT:
			if flick_counter % 2 == 0:
				hide()
				flick_counter = flick_counter + 1
			else:
				show()
				flick_counter = flick_counter + 1
		else:
			show()
			is_flicking = false
			flick_counter = 0
			return false


func _on_show_game_over():
	queue_free()


func set_speed(new_speed):
	speed = new_speed


func get_speed():
	return speed


func set_speed_factor(new_speed_factor):
	speed_factor = new_speed_factor


func get_speed_factor():
	return speed_factor


func set_direction(new_direction):
	direction = new_direction


func get_direction():
	return direction


func set_bias_position(new_bias_position):
	bias_position = new_bias_position


func set_from_spawn(new_from_spawn):
	from_spawn = new_from_spawn


func get_from_spawn():
	return from_spawn


func set_label(new_label):
	label = new_label


func get_label():
	return label
