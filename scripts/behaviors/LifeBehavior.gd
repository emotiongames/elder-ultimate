extends GridContainer

var is_game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var _player_damage_connection = Events.connect("player_damage", self, "_on_damage")
	var _resume_game_connection = Events.connect("resume_game", self, "_on_resume_game")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.get_child_count() == 0 and not is_game_over:
		game_over()

func _on_damage(local):
	if self.get_child_count() > 0:
		if local == "on_sidewalk":
			self.remove_child(self.get_child(self.get_child_count() - 1))
		elif local == "on_street":
			for child in self.get_children():
				self.remove_child(child)

func game_over():
	Events.emit_signal("show_game_over")
	is_game_over = true
	

func _on_resume_game():
	for i in [1, 2]:
		var heart = preload("res://scenes/screens/ui/elements/singles/Heart.tscn")
		var heart_instance = heart.instance()
		self.add_child(heart_instance)
	is_game_over = false
