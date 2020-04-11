extends ParallaxBackground


const SPEED_INCREMENT = 0.1


export var id = -1


var scroll_speed = 0
var aux_scroll_speed = 0
var width = 0
var running_speed = 0.7

var decrease_speed = false
var increase_speed = false
var do_effect = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if id == 0:
		scroll_speed = Utils.get_speed("FAR_SCROLL")
	elif id == 1:
		scroll_speed = Utils.get_speed("CLOSE_SCROLL")
	aux_scroll_speed = scroll_speed
	
	do_connections()


func do_connections():
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
	var _scroll_speed_effect_connection = Events.connect(
		"scroll_speed_effect",
		self,
		"_on_scroll_speed_effect"
	)
	var _increase_scroll_speed_connection = Events.connect(
		"increase_scroll_speed",
		self,
		"_on_increase_scroll_speed"
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)


func move(delta):
	if do_effect:
		if increase_speed:
			if scroll_speed >= aux_scroll_speed:
				increase_speed = false
				do_effect = false
			scroll_speed = lerp(scroll_speed, aux_scroll_speed, delta * running_speed)
			Events.emit_signal("scroll_speed_updated", scroll_speed)
		elif decrease_speed:
			if scroll_speed <= aux_scroll_speed/2:
				decrease_speed = false
				do_effect = false
			scroll_speed = lerp(scroll_speed, aux_scroll_speed/2, delta * running_speed)
			Events.emit_signal("scroll_speed_updated", scroll_speed)
	$ParallaxLayer.motion_offset.x -= scroll_speed


func _on_show_game_over():
	if do_effect:
		do_effect = false
		decrease_speed = false
		increase_speed = false
	aux_scroll_speed = scroll_speed
	scroll_speed = 0


func _on_resume_game():
	scroll_speed = aux_scroll_speed


func _on_scroll_speed_effect(action):
	if action == "decrement":
		do_effect = true
		decrease_speed = true
		increase_speed = false
		Events.emit_signal(
			"update_timer",
			"distance_score",
			0.4
		)
		Events.emit_signal("start_timer", "distance_score")
	elif action == "increment":
		do_effect = true
		decrease_speed = false
		increase_speed = true
		Events.emit_signal(
			"update_timer",
			"distance_score",
			0.2
		)
		Events.emit_signal("start_timer", "distance_score")
