extends MarginContainer

var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var _count_coin_connect = Events.connect("count_coin", self, "_on_count_coin")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.get_child(0).text = str(coins)

func _on_count_coin(coin):
	coins = coins + coin
