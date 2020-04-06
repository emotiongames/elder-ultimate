extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var _main_menu_connection = Events.connect("show_main_menu", self, "_on_show_main_menu")
	
	var _game_start_connect = Events.connect("game_start", self, "_on_game_start")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_show_main_menu():
	queue_free()
	get_tree().change_scene("res://scenes/screens/main-menu/MainMenu.tscn")


func _on_CountdownTimer_timeout():
	Events.emit_signal("decrement_countdown")
	pass # Replace with function body.

func _on_game_start():
	self.get_child(5).show()
