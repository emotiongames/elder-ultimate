extends Node

const SCROLL_SPEED = 1200
const SPEED_FROM = {
	"SCROLL": SCROLL_SPEED,
	"COIN": SCROLL_SPEED,
	"LIFE_INCREMENT": SCROLL_SPEED * 1.1,
	"EFFECT": SCROLL_SPEED * 1.2,
	"SIDEWALK_ENEMY": SCROLL_SPEED,
	"STREET_CAR_L_ENEMY": SCROLL_SPEED * 1.6,
	"STREET_CAR_R_ENEMY": SCROLL_SPEED * 0.6,
	"STREET_POLICE_L_ENEMY": SCROLL_SPEED * 1.4,
	"STREET_POLICE_R_ENEMY": SCROLL_SPEED * 0.4
}
const FACTOR_FROM = {
	"SCROLL": 1,
	"COIN": 1,
	"LIFE_INCREMENT": 1.1,
	"EFFECT": 1.2,
	"SIDEWALK_ENEMY": 1,
	"STREET_CAR_L_ENEMY": 1.6,
	"STREET_CAR_R_ENEMY": 0.6,
	"STREET_POLICE_L_ENEMY":  1.4,
	"STREET_POLICE_R_ENEMY": 0.4 
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func random_range(value_range):
	randomize()
	return int(rand_range(value_range[0], value_range[1]))

func get_speed(from : String):
	if SPEED_FROM.has(from):
		return SPEED_FROM[from]
	else:
		return null

func get_speed_factor(from : String):
	if FACTOR_FROM.has(from):
		return FACTOR_FROM[from]
	else:
		return null
