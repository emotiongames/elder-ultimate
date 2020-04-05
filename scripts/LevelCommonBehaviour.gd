extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var _main_menu_connection = Events.connect("show_main_menu", self, "_on_show_main_menu")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_show_main_menu():
	queue_free()
	get_tree().change_scene("res://scenes/screens/main-menu/MainMenu.tscn")
