extends Area2D

export var speed = 1200

var bias_position = Vector2(0, 0)
var spawn_position = Vector2(0, 0)

var freq = 5
var amplitude = 130
var time = 0
var velocity = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_width = ProjectSettings.get_setting("display/window/size/width")
	var life_width = self.get_child(0).texture.get_width()
	
	spawn_position = self.position
	bias_position.x = spawn_position.x + screen_width + life_width
	
	add_to_group("life_increment")
	var _show_game_over_connection = Events.connect("show_game_over", self, "_on_show_game_over")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)

func move(delta):
	time += delta
	#sin(PI/2 + time*freq)*amplitude
	velocity = Vector2(-speed, cos(time*freq)*amplitude)
	
	self.translate(velocity * delta)
	
	if self.position.x <= -bias_position.x:
		var timer = Utils.random_range([6, 15])
		Events.emit_signal("update_timer", "life_spawn", timer)
		Events.emit_signal("start_timer", "life_spawn")
		queue_free()

func _on_Heart_area_entered(area):
	if area.is_in_group("player"):
		Events.emit_signal("life_increment")
		queue_free()

func _on_show_game_over():
	queue_free()
	pass
