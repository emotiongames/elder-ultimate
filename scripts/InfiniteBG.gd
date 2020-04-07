extends Node2D

export var id = -1

var scroll_speed = 0
var aux_scroll_speed = 0
var width = 0
var running_speed = 0.7

var decrease_speed = false
var increase_speed = false
var do_effect = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var _show_game_over_connection = Events.connect("show_game_over", self, "_on_show_game_over")
	var _resume_game_connection = Events.connect("resume_game", self, "_on_resume_game")
	var _use_effect_connect = Events.connect("use_effect", self, "_on_use_effect")
	var _stop_effect_connect = Events.connect("stop_effect", self, "_on_stop_effect")
	
	scroll_speed = Utils.get_speed("SCROLL")
	aux_scroll_speed = scroll_speed
	width = int(self.get_child(0).texture.get_width() * self.get_child(0).scale.x)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)

func move(delta):
	if do_effect:
		if increase_speed:
			if scroll_speed >= aux_scroll_speed:
				increase_speed = false
				do_effect = false
			scroll_speed = lerp(scroll_speed, aux_scroll_speed, delta * running_speed)
			Events.emit_signal("scroll_speed_updated", scroll_speed)
		elif decrease_speed:
			if scroll_speed <= aux_scroll_speed/2:
				decrease_speed = false
				do_effect = false
			scroll_speed = lerp(scroll_speed, aux_scroll_speed/2, delta * running_speed)
			Events.emit_signal("scroll_speed_updated", scroll_speed)

	self.get_child(0).translate(Vector2(-scroll_speed * delta, 0))
	self.get_child(1).translate(Vector2(-scroll_speed * delta, 0))
	
	if self.get_child(0).position.x <= -width:
		self.get_child(0).position.x = width
		
	if self.get_child(1).position.x <= -width:
		self.get_child(1).position.x = width

func _on_show_game_over():
	scroll_speed = 0

func _on_resume_game():
	scroll_speed = aux_scroll_speed
	pass

func _on_use_effect(label):
	if label == "reduce_speed":
		do_effect = true
		decrease_speed = true

func _on_stop_effect(label):
	if label == "reduce_speed":
		decrease_speed = false
		increase_speed = true
		do_effect = true
