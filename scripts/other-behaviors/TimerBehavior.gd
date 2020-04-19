extends Timer


export var label = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	do_connections()
	pass # Replace with function body.


func do_connections():
	var _start_timer_connection = Events.connect(
		"start_timer",
		self,
		"_on_start_timer"
	)
	var _pause_timer_connection = Events.connect(
		"stop_timer",
		self,
		"_on_stop_timer"
	)
	var _update_timer_connection = Events.connect(
		"update_timer",
		self,
		"_on_update_timer"
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


func _on_start_timer(local_label):
	if label == local_label:
		self.start()


func _on_stop_timer(local_label):
	if label == local_label:
		self.stop()


func _on_show_game_over():
	self.stop()


func _on_resume_game():
	if(
		label != "life_spawn"
		and label != "effect_duration"
	):
		self.start()


func _on_update_timer(local_label, value):
	if label == local_label:
		self.wait_time = value
