extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_MainMenuButton_pressed():
	Events.emit_signal("show_main_menu")
