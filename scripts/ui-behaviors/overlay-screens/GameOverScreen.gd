extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	
	do_connections()


func do_connections():
	var _show_game_over_connection = Events.connect(
		"show_game_over",
		self,
		"_on_show_game_over"
	)
	var _resume_game_connection = Events.connect(
		"resume_game",
		self,
		"_on_resume_game"
	)


func _on_show_game_over():
	self.visible = true


func _on_resume_game():
	self.visible = false
