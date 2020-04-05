extends LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func js_text_entry():
    text = JavaScript.eval(
            "prompt('%s', '%s');" % ["Type your password:", text], 
            true
            )

func _on_PasswordTextBar_focus_entered():
	js_text_entry()
	emit_signal("text_changed", text)
	release_focus()
