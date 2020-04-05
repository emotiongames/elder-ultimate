extends Node2D

var coin_patterns = [
	preload("res://scenes/chapters/first/rewards/containers/coin-patterns/Pattern1.tscn")
]

var do_spawn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var _show_game_over_connection = Events.connect("show_game_over", self, "_on_show_game_over")
	var _resume_game_connection = Events.connect("resume_game", self, "_on_resume_game")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_show_game_over():
	do_spawn = false

func _on_resume_game():
	do_spawn = true

func _on_EffectTimer_timeout():
	#spawn_effect()
	#randomize()
	#Events.emit_signal("update_timer", "effect_spawn", int(rand_range(5, 7)))
	pass # Replace with function body.
	
func spawn_effect():
	#randomize()
	#var reward_spawn = int(rand_range(0, self.get_child_count()))
	pass

func _on_CoinGroupSpawnTimer_timeout():
	if do_spawn:
		spawn_coin_group()
		randomize()
		Events.emit_signal("update_timer", "coin_group_spawn", int(rand_range(1, 3)))
	pass # Replace with function body.

func spawn_coin_group():
	var coin_group_instance = coin_patterns[0].instance()
	self.get_child(0).add_child(coin_group_instance)
