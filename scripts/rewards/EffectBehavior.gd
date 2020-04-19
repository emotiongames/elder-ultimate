extends Area2D


export var speed = 1200


var label = "" setget set_label

var bias_position = Vector2(0, 0)
var spawn_position = Vector2(0, 0)

var freq = 5
var amplitude = 130
var time = 0
var velocity = 0
var speed_factor = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_width = ProjectSettings.get_setting("display/window/size/width")
	var life_width = self.get_child(0).texture.get_width()
	
	speed = Utils.get_speed("EFFECT")
	spawn_position = self.position
	bias_position.x = spawn_position.x + screen_width + life_width
	speed_factor = Utils.get_speed_factor("EFFECT")
	
	add_to_group("effects")
	do_connections()


func do_connections():
	var _area_entered_connection =  connect(
		"area_entered",
		self,
		"_on_area_entered"
	)
	var _show_game_over_connection = Events.connect(
		"show_game_over",
		self,
		"_on_show_game_over"
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)


func move(delta):
	time += delta
	velocity = Vector2(-speed, sin(PI/2 + time*freq)*amplitude)
	
	self.translate(velocity * delta)
	
	if self.position.x <= -bias_position.x:
		var timer = Utils.random_range([7, 13])
		Events.emit_signal("update_timer", "effect_spawn", timer)
		Events.emit_signal("start_timer", "effect_spawn")
		queue_free()


func _on_show_game_over():
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("player"):
		Events.emit_signal("start_effect_behavior", label)
		queue_free()


func set_label(new_label):
	label = new_label
