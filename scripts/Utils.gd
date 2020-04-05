extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func create_timer(wait_time):
	var timer = Timer.new()
	timer.set_wait_time(wait_time)
	timer.set_one_shot(true)
	timer.connect("timeout", timer, "queue_free")
	add_child(timer)
	timer.start()
	return timer

func random_range(value_range):
	randomize()
	return int(rand_range(value_range[0], value_range[1]))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
