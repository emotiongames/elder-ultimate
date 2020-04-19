class_name EffectBase
extends Node


enum Status {
		UNAVAILABLE,
		AVAILABLE,
		READY_TO_USE,
		RUNNING,
		DONE,
	}


var label: String = "" setget set_label, get_label
var duration_time: int = 0 setget set_duration_time, get_duration_time # in seconds
var state = Status.UNAVAILABLE setget set_state, get_state


func _init():
	add_to_group("effects")
	pass
	#


# Called when the node enters the scene tree for the first time.
func _ready():
	#Events.emit_signal("start_effect_shuffle", label)
	pass # Replace with function body.


func set_label(new_label):
	label = new_label


func get_label():
	return label


func set_duration_time(new_duration_time):
	duration_time = new_duration_time


func get_duration_time():
	return duration_time


func set_state(new_state):
	match new_state:
		"available": 
			state = Status.AVAILABLE
		"ready_to_use": 
			state = Status.READY_TO_USE
		"running": 
			state = Status.RUNNING
		"done": 
			state = Status.DONE


func get_state():
	return state
