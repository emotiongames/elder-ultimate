extends Area2D


const FLICK_LIMIT = 31


var speed = 300 setget set_speed
var orientation = 0 setget set_orientation
var from_spawn = -1 setget set_from_spawn
var label = "" setget set_label

var collision_with_player_moving = false
var collision_with_player_stopped = false
var is_flicking = false

var spawn_position = Vector2(0, 0)
var bias_position = Vector2(0, 0)

var player_collision = -1
var speed_factor = 0
var flick_counter = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_width = ProjectSettings.get_setting("display/window/size/width")
	var enemy_width = self.get_child(0).texture.get_width()
	
	spawn_position = self.position
	bias_position.x = screen_width + enemy_width + spawn_position.x
	speed_factor = Utils.get_speed_factor(label)
	speed = Utils.get_speed(label)
	
	add_to_group("enemy")
	do_connections()


func do_connections():
	var _area_entered_connection =  connect(
		"area_entered",
		self,
		"_on_area_entered"
	)
	var _show_game_over_connection = Events.connect(
		"show_game_over",
		self,
		"_on_show_game_over"
	)
	var _scroll_speed_updated_connect = Events.connect(
		"scroll_speed_updated",
		self,
		"_on_scroll_speed_updated"
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	detect_collision()
	flick_verification()


func move(delta):
	self.translate(Vector2((speed * delta) * orientation, 0))
	if orientation == -1:
		if self.position.x <= -bias_position.x:
			queue_free()
	elif orientation == 1:
		if self.position.x >= bias_position.x:
			queue_free()


func detect_collision():
	if from_spawn in [0, 1, 6, 7] and from_spawn == player_collision:
		if collision_with_player_stopped:
			collision_with_player_stopped = false
			player_collision = -1
			queue_free()
	elif from_spawn in [2, 5] and from_spawn == player_collision:
		if collision_with_player_moving:
			collision_with_player_moving = false
			player_collision = -1
			queue_free()


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
	if other.is_in_group("player"):
		collision_with_player_moving = other.to_down or other.to_up
		collision_with_player_stopped = other.on_bottom or other.on_top
		player_collision = other.on_collision_with_enemy
	if other.is_in_group("power"):
		is_flicking = true


func _on_show_game_over():
	queue_free()


func _on_scroll_speed_updated(new_speed):
	if from_spawn in [0, 6]:
		speed = new_speed * speed_factor


func set_speed(new_speed):
	speed = new_speed


func set_orientation(new_orientation):
	orientation = new_orientation


func set_bias_position(new_bias_position):
	bias_position = new_bias_position


func set_from_spawn(new_from_spawn):
	from_spawn = new_from_spawn


func set_label(new_label):
	label = new_label
