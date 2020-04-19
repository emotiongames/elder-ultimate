extends Node


const SCROLL_SPEED = 20.0

const SPEED_FROM = {
	"FAR_SCROLL": SCROLL_SPEED * 0.015,
	"CLOSE_SCROLL": SCROLL_SPEED,
	"COIN": SCROLL_SPEED * 60.0,
	"LIFE_INCREMENT": SCROLL_SPEED * 66.0,
	"EFFECT": SCROLL_SPEED * 72.0,
	"CONTAMINATED": SCROLL_SPEED * 60.0,
	"CAR_TO_LEFT": SCROLL_SPEED * 96.0,
	"CAR_TO_RIGHT": SCROLL_SPEED * 36.0,
	"POLICE_CAR_TO_LEFT": SCROLL_SPEED * 84.0,
	"POLICE_CAR_TO_RIGHT": SCROLL_SPEED * 24.0
}
const FACTOR_FROM = {
	"FAR_SCROLL": 0.015,
	"CLOSE_SCROLL": 1,
	"COIN": 60.0,
	"LIFE_INCREMENT": 66.0,
	"EFFECT": 72.0,
	"CONTAMINATED": 60.0,
	"CAR_TO_LEFT": 96.0,
	"CAR_TO_RIGHT": 36.0,
	"POLICE_CAR_TO_LEFT":  84.0,
	"POLICE_CAR_TO_RIGHT": 24.0 
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func random_range(value_range):
	randomize()
	return int(rand_range(value_range[0], value_range[1]))


func get_noise(noise):
	randomize()
	return noise.get_noise_2d(randf(), randf())


func get_speed(from : String):
	if SPEED_FROM.has(from):
		return SPEED_FROM[from]
	else:
		return 0


func get_speed_factor(from : String):
	if FACTOR_FROM.has(from):
		return FACTOR_FROM[from]
	else:
		return 0.0
