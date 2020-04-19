extends EnemyBase


# Called when the node enters the scene tree for the first time.
func _ready():
	.set_label("CAR_TO_RIGHT")
	.set_speed(Utils.get_speed(self.label))
	.set_speed_factor(Utils.get_speed_factor(self.label))
	.set_direction(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.position.x >= self.bias_position.x:
		queue_free()


func _on_scroll_speed_updated(_new_speed):
	#self.speed = new_speed * self.speed_factor
	pass


func _on_area_entered(other):
	if other.is_in_group("player") and not self.is_flicking:
		if other.to_up or other.to_down:
			queue_free()
	if other.is_in_group("power") and not self.is_flicking:
		self.is_flicking = true
