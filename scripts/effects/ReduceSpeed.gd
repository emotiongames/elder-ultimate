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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_label():
	return .get_label()


func get_duration_time():
	return .get_duration_time()


func set_state(new_state):
	.set_state(new_state)


func get_state():
	return .get_state()


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
