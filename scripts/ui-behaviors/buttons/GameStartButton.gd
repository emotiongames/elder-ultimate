extends Button


var password = ""
var host = "https://api.backendless.com/2C4A95E1-350F-9088-FF00-61C030C97100/E736C626-131A-469C-B577-25EBEA7EA772"
var path = "/services/testers_api/exists?password="


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_GameStartButton_pressed():
	validate_password()


func validate_password():
	if password.length() == 6 and password.is_valid_integer():
		var http_request = get_parent().get_child(1)
		Events.emit_signal("update_message_text", "Connecting with remote server.")
		http_request.request(host + path + password)
	elif password.empty():
		Events.emit_signal("update_message_text", "Type your password.")
	else:
		Events.emit_signal("update_message_text", "Invalid password.")


func _on_PasswordTextBar_text_changed(new_text):
	password = new_text


func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		if body.get_string_from_utf8() == "1":
			queue_free()
			var _scene_changed = get_tree().change_scene("res://scenes/chapters/first/GameScene.tscn")
		else:
			Events.emit_signal("update_message_text", "Invalid password.")
	else:
		Events.emit_signal("update_message_text", "Server Error.")
