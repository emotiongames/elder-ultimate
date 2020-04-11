extends Node2D


var speed = 0 setget set_speed


# Called when the node enters the scene tree for the first time.
func _ready():
	do_connections()
	update_child_speed()


func do_connections():
	var _show_game_over_connection = Events.connect(
		"show_game_over",
		self,
		"_on_show_game_over"
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_child_speed():
	for coin in self.get_children():
		coin.set_speed(speed)


func _on_show_game_over():
	queue_free()


func set_speed(new_speed):
	speed = new_speed
