extends ParallaxBackground

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
	var _show_game_over_connection = Events.connect("show_game_over", self, "_on_show_game_over")
	var _resume_game_connection = Events.connect("resume_game", self, "_on_resume_game")
	var _use_effect_connect = Events.connect("use_effect", self, "_on_use_effect")
	var _stop_effect_connect = Events.connect("stop_effect", self, "_on_stop_effect")
	
	if id == 0:
		scroll_speed = Utils.get_speed("FAR_SCROLL")
	elif id == 1:
		scroll_speed = Utils.get_speed("CLOSE_SCROLL")
	aux_scroll_speed = scroll_speed
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	pass

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
	scroll_speed = 0

func _on_resume_game():
	scroll_speed = aux_scroll_speed
	pass

func _on_use_effect(label):
	if label == "reduce_speed":
		do_effect = true
		decrease_speed = true
		Events.emit_signal("update_timer", "distance_score", 0.4)
		Events.emit_signal("start_timer", "distance_score")

func _on_stop_effect(label):
	if label == "reduce_speed":
		decrease_speed = false
		increase_speed = true
		do_effect = true
		Events.emit_signal("update_timer", "distance_score", 0.2)
		Events.emit_signal("start_timer", "distance_score")
