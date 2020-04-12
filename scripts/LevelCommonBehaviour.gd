extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready():
	
	do_connections()


func do_connections():
	var _main_menu_connection = Events.connect(
		"show_main_menu",
		self,
		"_on_show_main_menu"
	)
	var _game_start_connect = Events.connect(
		"game_start",
		self,
		"_on_game_start"
	)


# func _process(_delta):
#	pass





func _on_show_main_menu():
	queue_free()
	var _scene_changed = get_tree().change_scene("res://scenes/screens/main-menu/MainMenu.tscn")


func _on_CountdownTimer_timeout():
	Events.emit_signal("decrement_countdown")


func _on_game_start():
	self.get_node("GameUI").show()
