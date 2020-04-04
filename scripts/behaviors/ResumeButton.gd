extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#if self.pressed:
		#Events.emit_signal("resume_game")
	pass

func _on_ResumeButton_pressed():
	Events.emit_signal("resume_game")
	pass # Replace with function body.
