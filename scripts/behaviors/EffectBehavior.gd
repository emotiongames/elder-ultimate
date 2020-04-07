extends Area2D

export var speed = 1200
export var label = ""

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
	var _area_entered_connection =  connect("area_entered", self, "_on_area_entered")
	var _show_game_over_connection = Events.connect("show_game_over", self, "_on_show_game_over")
	var _scroll_speed_updated_connect = Events.connect("scroll_speed_updated", self, "_on_scroll_speed_updated")
		
	speed = Utils.get_speed("EFFECT")
	
	spawn_position = self.position
	bias_position.x = spawn_position.x + screen_width + life_width
	add_to_group("effects")

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
		Events.emit_signal("start_effect_shuffle", label)
		queue_free()

func _on_scroll_speed_updated(new_speed):
	speed = new_speed * Utils.get_speed_factor("EFFECT")
