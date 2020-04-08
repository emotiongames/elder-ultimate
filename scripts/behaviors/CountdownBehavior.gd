extends Label

const DEFAULT_VALUE = 3
const DEFAULT_TEXT = "3"

var countdown = DEFAULT_VALUE

# Called when the node enters the scene tree for the first time.
func _ready():
	var _decrement_countdown_connection = Events.connect("decrement_countdown", self, "_on_decrement_countdown")
	var _resume_game_connection = Events.connect("resume_game", self, "_on_resume_game")
	
	self.hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_decrement_countdown():
	if countdown == 0:
		self.text = "GO!"
		Events.emit_signal("game_start")
		countdown = -1
	elif countdown == -1:
		countdown = DEFAULT_VALUE
		self.text = DEFAULT_TEXT
		self.hide()
		Events.emit_signal("stop_timer", "countdown")
		Events.emit_signal("update_timer", "countdown", 1)
	elif countdown == DEFAULT_VALUE:
		started_countdown()
	else:
		self.text = str(countdown)
		countdown = countdown - 1

func _on_resume_game():
	started_countdown()

func started_countdown():
	self.show()
	countdown = countdown - 1
