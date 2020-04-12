extends Area2D


var t = 0.0
var speed = 0.75
var rotation_speed = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	var _area_entered_connection = connect(
		"area_entered", self, "_on_area_entered"
	)
	add_to_group("power")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta * speed
	position = self.get_parent().curve.interpolate_baked(t * self.get_parent().curve.get_baked_length(), true)
	rotation = rotation + (rotation_speed * delta)
	
	if self.position <= self.get_parent().position:
		queue_free()
		Events.emit_signal("power_ended")
	pass

func _on_area_entered(other):
	if other.is_in_group("enemy"):
		queue_free()
		Events.emit_signal("power_ended")
