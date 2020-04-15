extends Node2D


signal launch_power

signal move_to(direction)


const DOUBLE_TAP_TIME_LIMIT = 0.5


onready var power_spawn = get_node("Player/PowerLaunch")
onready var top_limit = get_node("TopLimit")
onready var bottom_limit = get_node("BottomLimit")
onready var player = get_node("Player")

var power = preload("res://scenes/chapters/first/characters/main/Power.tscn")

var screen_width = 0
var count_power_on_scene = 0
var tap_counter = 0

var time_between_taps = 0.0

var is_game_over = false
var double_tap = false
var double_tap_started = false
var to_up = false
var to_down = false
var on_top = true
var on_bottom = false
var block_input = false
var right_side = false
var left_side = false


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_width = ProjectSettings.get_setting("display/window/size/width")
	do_connections()


func do_connections():
	var _power_ended_connection = Events.connect("power_ended", self, "_on_power_ended")
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	verify_double_tap(delta)


func verify_double_tap(delta):
	if double_tap_started:
		time_between_taps += delta
		if time_between_taps <= DOUBLE_TAP_TIME_LIMIT and tap_counter == 2:
			double_tap = true
			double_tap_started = false
			time_between_taps = 0.0
		if time_between_taps > DOUBLE_TAP_TIME_LIMIT:
			double_tap_started = false
			time_between_taps = 0.0
			tap_counter = 0


func _input(event):
	if not block_input:
		if event.position.x > screen_width/2:
			right_side = true
			left_side = false
		elif event.position.x < screen_width/2:
			right_side = false
			left_side = true
		else:
			right_side = false
			left_side = false
		power_input(event)
		effect_input(event)


func power_input(ev):
	if(
		ev is InputEventScreenTouch
		and left_side
		and ev.pressed
		and not is_game_over
	):
		if not double_tap_started:
			double_tap_started = true
		tap_counter += 1
	elif(
		ev is InputEventMouseButton
		and Input.is_action_pressed("ui_touch")
		and ev.pressed
		and ev.doubleclick
		and left_side
		and not is_game_over
	):
		double_tap = true
	
	if double_tap and count_power_on_scene < 1 and left_side:
		count_power_on_scene += 1
		var power_instance = power.instance()
		power_spawn.add_child(power_instance)
		tap_counter = 0
		double_tap = false


func effect_input(ev):
	if(
		ev is InputEventScreenTouch
		and right_side
		and ev.pressed
		and not is_game_over
	):
		if not double_tap_started:
			double_tap_started = true
		tap_counter += 1
	elif(
		ev is InputEventMouseButton
		and Input.is_action_pressed("ui_touch")
		and ev.pressed
		and ev.doubleclick
		and right_side
		and not is_game_over
	):
		double_tap = true
	
	if double_tap and right_side:
		Events.emit_signal("run_effect")
		tap_counter = 0
		double_tap = false


func _on_power_ended():
	count_power_on_scene -= 1


func _on_show_game_over():
	is_game_over = true


func _on_resume_game():
	is_game_over = false


func _on_SwipeDetector_swipe_started(_partial_gesture):
	block_input = true


func _on_SwipeDetector_swipe_failed():
	block_input = false


func _on_SwipeDetector_swiped(gesture):
	if block_input:
		if gesture.get_direction() == "up" and not on_top:
			to_up = true
			to_down = false
		elif gesture.get_direction() == "down" and not on_bottom:
			to_up = false
			to_down = true
		emit_signal("move_to", gesture.get_direction())
		block_input = false


func _on_Player_final_position(position):
	match position:
		"top": 
			on_top = true
			on_bottom = false
		"bottom": 
			on_top = false
			on_bottom = true
