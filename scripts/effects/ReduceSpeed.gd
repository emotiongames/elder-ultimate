extends EffectBase


const EFFECT_LABEL = "reduce_speed"
const EFFECT_DURATION = 5.0


var action = ""


func _init():
	.set_label(EFFECT_LABEL)
	.set_duration_time(EFFECT_DURATION/2.0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start():
	Events.emit_signal("remove_effect_from_ui")
	Events.emit_signal("scroll_speed_effect", "decrement")
	Events.emit_signal("update_timer", "effect_duration", .get_duration_time())
	Events.emit_signal("start_timer", "effect_duration")
	.set_state("running")
	action = "decrementing"
	pass


func stop():
	if action == "decrementing":
		Events.emit_signal("scroll_speed_effect", "increment")
		Events.emit_signal("update_timer", "effect_duration", .get_duration_time())
		Events.emit_signal("start_timer", "effect_duration")
		action = "incrementing"
	elif action == "incrementing":
		.set_state("done")
		action = ""
	pass
