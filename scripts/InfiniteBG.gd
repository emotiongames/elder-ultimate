extends Node2D

export var scroll_speed = 0
export var id = -1

var aux_scroll_speed = 0
var width = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var _show_game_over_connection = Events.connect("show_game_over", self, "_on_show_game_over")
	var _resume_game_connection = Events.connect("resume_game", self, "_on_resume_game")
	aux_scroll_speed = scroll_speed
	width = int(self.get_child(0).texture.get_width() * self.get_child(0).scale.x)
	
	#while true:
		#Events.emit_signal("count_point", 1)
		#yield(Utils.create_timer(1.5), "timeout")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.get_child(0).translate(Vector2(-scroll_speed * delta, 0))
	self.get_child(1).translate(Vector2(-scroll_speed * delta, 0))
	
	if self.get_child(0).position.x <= -width:
		self.get_child(0).position.x = width
		
	if self.get_child(1).position.x <= -width:
		self.get_child(1).position.x = width
	
func _on_show_game_over():
	scroll_speed = 0

func _on_resume_game():
	scroll_speed = aux_scroll_speed
