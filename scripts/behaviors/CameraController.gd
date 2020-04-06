extends Camera2D

const ZOOM_LIMIT = Vector2(1, 1)

export var speed = 0.6
export var zoom_speed = 0.7

var target = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	target = self.get_parent()
	pass # Replace with function body.

func _physics_process(delta):
	if not zoom >= ZOOM_LIMIT:
		zoom = lerp(self.zoom, ZOOM_LIMIT, delta * zoom_speed)
		set_global_position(
			lerp(get_global_position(), target.get_global_position(), delta*speed)
		)
