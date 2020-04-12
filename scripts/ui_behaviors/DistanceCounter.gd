extends MarginContainer


var points = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var _count_point_connection = Events.connect(
		"count_point",
		self,
		"_on_count_point"
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.get_child(0).text = str(points) + "m"


func _on_count_point(point):
	points = points + point
