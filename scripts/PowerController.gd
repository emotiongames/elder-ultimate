extends Position2D

var power = preload("res://scenes/chapters/first/characters/main/Power.tscn")

var screen_width = 0
var count_power_on_scene = 0

var is_game_over = false


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_width = ProjectSettings.get_setting("display/window/size/width")
	
	var _power_ended_connection = Events.connect("power_ended", self, "_on_power_ended")
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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(ev):
	if(
		ev is InputEventMouseButton
		and ev.pressed
		and ev.doubleclick
		and ev.position.x <= screen_width/2
		and count_power_on_scene < 2
		and not is_game_over
	):
		var power_instance = power.instance()
		self.add_child(power_instance)
		count_power_on_scene += 1


func _on_power_ended():
	count_power_on_scene -= 1


func _on_show_game_over():
	is_game_over = true


func _on_resume_game():
	is_game_over = false
