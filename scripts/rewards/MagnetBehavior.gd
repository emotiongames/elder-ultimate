extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_MagnetArea_area_entered(area):
	if area.is_in_group("coins"):
		area.seek_player = true
