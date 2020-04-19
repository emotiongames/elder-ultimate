extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var _update_message_text_connection = Events.connect(
		"update_message_text",
		self,
		"_on_update_message_text"
	)


func _on_update_message_text(new_text):
	self.text = new_text
