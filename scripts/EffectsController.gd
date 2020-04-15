extends Node2D


var Invencibility = load("res://scripts/effects/Invencibility.gd").new()
var ReduceSpeed = load("res://scripts/effects/ReduceSpeed.gd").new()

var actual_effect = EffectBase.new()
var last_effect = EffectBase.new()

var screen_width = 0
var tap_counter = 0
var time_between_taps = 0.0

var is_game_over = false
var double_tap = false
var double_tap_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_width = ProjectSettings.get_setting("display/window/size/width")
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
	var _resume_game_connection = Events.connect(
		"resume_game",
		self,
		"_on_resume_game"
	)
	var _run_effect_connection = Events.connect("run_effect", self, "_on_run_effect")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if double_tap_started:
		time_between_taps += delta
		if time_between_taps <= 0.5 and tap_counter == 2:
			double_tap = true
			double_tap_started = false
			time_between_taps = 0.0
		if time_between_taps > 0.5:
			double_tap_started = false
			time_between_taps = 0.0
			tap_counter = 0
	pass


#func _input(ev):
#	if(
#		ev is InputEventScreenTouch
#		and ev.position.x >= screen_width/2
#		and ev.pressed
#		and not is_game_over
#	):
#		if not double_tap_started:
#			double_tap_started = true
#		tap_counter += 1
#	elif(
#		ev is InputEventMouseButton
#		and Input.is_action_pressed("ui_touch")
#		and ev.pressed
#		and ev.doubleclick
#		and ev.position.x >= screen_width/2
#		and not is_game_over
#	):
#		double_tap = true
#
#	if double_tap:
#		if(
#			#actual_effect.get_label() == "invencibility" and
#			actual_effect.get_state() == EffectBase.Status.READY_TO_USE
#			and last_effect.get_state() == EffectBase.Status.DONE
#		):
#			actual_effect.start()
#		elif (
#			#actual_effect.get_label() == "reduce_speed" and
#			actual_effect.get_state() == EffectBase.Status.READY_TO_USE
#			and last_effect.get_state() == EffectBase.Status.DONE
#		):
#			actual_effect.start()
#		tap_counter = 0
#		double_tap = false


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
	is_game_over = true


func restart_state():
	actual_effect = EffectBase.new()
	last_effect = EffectBase.new()
	last_effect.set_state("done")


func _on_resume_game():
	is_game_over = false

func _on_run_effect():
	if(
		#actual_effect.get_label() == "invencibility" and
		actual_effect.get_state() == EffectBase.Status.READY_TO_USE
		and last_effect.get_state() == EffectBase.Status.DONE
	):
		actual_effect.start()
