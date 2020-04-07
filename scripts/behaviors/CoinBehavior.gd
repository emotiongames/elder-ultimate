extends Area2D

export var speed = 900 setget set_speed

var bias_position = Vector2(0, 0)
var spawn_position = Vector2(0, 0)

func set_speed(new_speed):
	speed = new_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_width = ProjectSettings.get_setting("display/window/size/width")
	var coin_width = self.get_child(0).texture.get_width()
	
	spawn_position = self.position
	bias_position.x = spawn_position.x + screen_width + coin_width
	
	add_to_group("coins")
	var _show_game_over_connection = Events.connect("show_game_over", self, "_on_show_game_over")
	var _scroll_speed_updated_connect = Events.connect("scroll_speed_updated", self, "_on_scroll_speed_updated")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)

func move(delta):
	self.translate(Vector2(-speed * delta, 0))
	if self.position.x <= -bias_position.x:
			queue_free()

func _on_Coin_area_entered(area):
	if area.is_in_group("player"):
		Events.emit_signal("count_coin", 1)
		queue_free()

func _on_show_game_over():
	queue_free()
	pass

func _on_scroll_speed_updated(new_speed):
	speed = new_speed
