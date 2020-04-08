extends Node2D

var speed = 0 setget set_speed

func set_speed(new_speed):
	speed = new_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	update_child_speed()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_child_speed():
	for coin in self.get_children():
		coin.set_speed(speed)
