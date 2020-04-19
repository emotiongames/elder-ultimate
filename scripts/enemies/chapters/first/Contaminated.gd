extends EnemyBase


# Called when the node enters the scene tree for the first time.
func _ready():
	.set_label("CONTAMINATED")
	.set_speed(Utils.get_speed(self.label))
	.set_speed_factor(Utils.get_speed_factor(self.label))
	.set_direction(-1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.position.x <= -self.bias_position.x:
		queue_free()


func _on_scroll_speed_updated(new_speed):
	self.speed = new_speed * self.speed_factor


func _on_area_entered(other):
	if other.is_in_group("player") and not is_flicking:
		if other.on_top and .get_from_spawn() == 0:
			queue_free()
		elif other.on_bottom and .get_from_spawn() == 6:
			queue_free()
	if other.is_in_group("power") and not is_flicking:
		is_flicking = true
