extends Area2D


var t = 0.0
var speed = 0.75
var rotation_speed = 15

var tap_counter = 0
var time_between_taps = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	var _area_entered_connection = connect(
		"area_entered", self, "_on_area_entered"
	)
	add_to_group("power")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta * speed
	position = self.get_parent().curve.interpolate_baked(t * self.get_parent().curve.get_baked_length(), true)
	rotation = rotation + (rotation_speed * delta)
	
	if self.position <= self.get_parent().position:
		queue_free()
		Events.emit_signal("power_ended")

func _on_area_entered(other):
	if other.is_in_group("enemy"):
		queue_free()
		Events.emit_signal("power_ended")
