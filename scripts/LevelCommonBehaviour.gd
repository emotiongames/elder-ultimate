extends Node2D

var effect_to_use = ""
var not_running_effect = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var _main_menu_connection = Events.connect("show_main_menu", self, "_on_show_main_menu")
	var _start_effect_shuffle_connect = Events.connect("start_effect_shuffle", self, "on_start_effect_shuffle")
	var _game_start_connect = Events.connect("game_start", self, "_on_game_start")
	
func _process(delta):
	pass

func _input(ev):
	if ev is InputEventMouseButton and ev.pressed and ev.doubleclick:
		if effect_to_use != "" and not_running_effect:
			Events.emit_signal("use_effect", effect_to_use)
			effect_to_use = ""
			not_running_effect = false

func _on_show_main_menu():
	queue_free()
	get_tree().change_scene("res://scenes/screens/main-menu/MainMenu.tscn")

func _on_CountdownTimer_timeout():
	Events.emit_signal("decrement_countdown")

func _on_game_start():
	self.get_node("GameUI").show()

func on_start_effect_shuffle(until_effect):
	effect_to_use = until_effect

func _on_EffectDurationTimer_timeout():
	not_running_effect = true
