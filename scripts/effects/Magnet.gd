extends EffectBase


const EFFECT_LABEL = "magnet"
const EFFECT_DURATION = 5


func _init():
	.set_label(EFFECT_LABEL)
	.set_duration_time(EFFECT_DURATION)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start():
	Events.emit_signal("remove_effect_from_ui")
	Events.emit_signal("player_magnet", true)
	Events.emit_signal("update_timer", "effect_duration", .get_duration_time())
	Events.emit_signal("start_timer", "effect_duration")
	.set_state("running")
	pass


func stop():
	Events.emit_signal("player_magnet", false)
	.set_state("done")
