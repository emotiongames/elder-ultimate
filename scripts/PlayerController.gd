extends Node2D


signal launch_power
signal run_effect


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
		if time_between_taps <= 0.5 and tap_counter == 2:
			double_tap = true
			double_tap_started = false
			time_between_taps = 0.0
		if time_between_taps > 0.5:
			double_tap_started = false
			time_between_taps = 0.0
			tap_counter = 0


func _input(event):
	power_input(event)
	effect_input(event)
	pass


func power_input(ev):
	if(
		ev is InputEventScreenTouch
		and ev.position.x <= screen_width/2
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
		and ev.position.x <= screen_width/2
		and not is_game_over
	):
		double_tap = true
	
	if double_tap and count_power_on_scene < 2:
		count_power_on_scene += 1
		var power_instance = power.instance()
		self.add_child(power_instance)
		tap_counter = 0
		double_tap = false


func effect_input(ev):
	pass


func _on_power_ended():
	count_power_on_scene -= 1


func _on_show_game_over():
	is_game_over = true


func _on_resume_game():
	is_game_over = false
