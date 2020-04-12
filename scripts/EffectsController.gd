extends Node2D


var Invencibility = load("res://scripts/effects/Invencibility.gd").new()
var ReduceSpeed = load("res://scripts/effects/ReduceSpeed.gd").new()

var actual_effect = EffectBase.new()
var last_effect = EffectBase.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	last_effect.set_state("done")
	do_connections()


func do_connections():
	var _start_effect_behavior_connect = Events.connect(
		"start_effect_behavior",
		self,
		"_on_start_effect_behavior"
	)
	var _update_effect_state_connect = Events.connect(
		"update_effect_state",
		self,
		"_on_update_effect_state"
	)
	var _show_game_over_connection = Events.connect(
		"show_game_over",
		self,
		"_on_show_game_over"
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass


func _input(ev):
	if ev is InputEventMouseButton and ev.pressed and ev.doubleclick:
		if(
			actual_effect.get_label() == "invencibility"
			and actual_effect.get_state() == EffectBase.Status.READY_TO_USE
			and last_effect.get_state() == EffectBase.Status.DONE
		):
			actual_effect.start()
		elif (
			actual_effect.get_label() == "reduce_speed"
			and actual_effect.get_state() == EffectBase.Status.READY_TO_USE
			and last_effect.get_state() == EffectBase.Status.DONE
		):
			actual_effect.start()


func _on_start_effect_behavior(label):
	match label:
		"invencibility":
			Events.emit_signal("start_effect_shuffle", label)
			actual_effect = Invencibility
			actual_effect.set_state("available")
		"reduce_speed":
			Events.emit_signal("start_effect_shuffle", label)
			actual_effect = ReduceSpeed
			actual_effect.set_state("available")


func _on_update_effect_state(state):
	match state:
		"ready_to_use":
			actual_effect.set_state(state)


func _on_EffectDurationTimer_timeout():
	actual_effect.stop()
	if actual_effect.get_state() == EffectBase.Status.DONE:
		restart_state()


func _on_show_game_over():
	restart_state()


func restart_state():
	actual_effect = EffectBase.new()
	last_effect = EffectBase.new()
	last_effect.set_state("done")
