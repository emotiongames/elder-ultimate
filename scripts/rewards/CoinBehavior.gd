extends Area2D


export var speed = 900 setget set_speed

var bias_position = Vector2(0, 0)
var spawn_position = Vector2(0, 0)
var player_last_position = Vector2(0, 0)

var speed_factor = 0

var seek_player = false


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("coins")
	
	var screen_width = ProjectSettings.get_setting("display/window/size/width")
	var coin_width = self.get_child(0).texture.get_width()
	
	spawn_position = self.position
	bias_position.x = spawn_position.x + screen_width + coin_width
	speed_factor = Utils.get_speed_factor("COIN")
	
	do_connections()


func do_connections():
	var _scroll_speed_updated_connect = Events.connect(
		"scroll_speed_updated",
		self,
		"_on_scroll_speed_updated"
	)
	var _player_position_updated_connect = Events.connect(
		"player_position_updated",
		self,
		"_on_player_position_updated"
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)


func move(delta):
	if seek_player:
		var direction = (player_last_position - self.global_position).normalized()
		self.translate(direction * 25)
	else:
		self.translate(Vector2(-speed * delta, 0))
	if self.position.x <= -bias_position.x:
			queue_free()


func _on_Coin_area_entered(area):
	if area.is_in_group("player"):
		Events.emit_signal("count_coin", 1)
		$CoinAudio.play()
		hide()


func _on_scroll_speed_updated(new_speed):
	speed = new_speed * speed_factor


func set_speed(new_speed):
	speed = new_speed


func _on_player_position_updated(position):
	player_last_position = position


func _on_CoinAudio_finished():
	queue_free()
