extends Node2D

var coin_patterns = [
	preload("res://scenes/chapters/first/rewards/containers/coin-patterns/Pattern1.tscn"),
	preload("res://scenes/chapters/first/rewards/containers/coin-patterns/Pattern2.tscn"),
	preload("res://scenes/chapters/first/rewards/containers/coin-patterns/Pattern3.tscn"),
	preload("res://scenes/chapters/first/rewards/containers/coin-patterns/Pattern4.tscn"),
	preload("res://scenes/chapters/first/rewards/containers/coin-patterns/Pattern5.tscn"),
	preload("res://scenes/chapters/first/rewards/containers/coin-patterns/Pattern6.tscn"),
	preload("res://scenes/chapters/first/rewards/containers/coin-patterns/Pattern7.tscn"),
	preload("res://scenes/chapters/first/rewards/containers/coin-patterns/Pattern8.tscn"),
	preload("res://scenes/chapters/first/rewards/containers/coin-patterns/Pattern9.tscn"),
	preload("res://scenes/chapters/first/rewards/containers/coin-patterns/Pattern10.tscn"),
	preload("res://scenes/chapters/first/rewards/containers/coin-patterns/Pattern11.tscn")
]

var life = [
	preload("res://scenes/chapters/first/rewards/single/Alcohol.tscn")
]

var effects = [
	preload("res://scenes/chapters/first/rewards/single/Invencibility.tscn"),
	preload("res://scenes/chapters/first/rewards/single/ReduceSpeed.tscn")
]

var do_spawn = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var _show_game_over_connection = Events.connect("show_game_over", self, "_on_show_game_over")
	var _game_start_connect = Events.connect("game_start", self, "_on_game_start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_show_game_over():
	do_spawn = false

func _on_EffectTimer_timeout():
	if do_spawn:
		spawn_effect()
		Events.emit_signal("update_timer", "effect_spawn", Utils.random_range([13, 30]))

func spawn_effect():
	var effect_to_spawn = Utils.random_range([0, effects.size()])
	var effect_instance = effects[effect_to_spawn].instance()
	var spawn_index = Utils.random_range([1, self.get_child_count()])
	self.get_child(spawn_index).add_child(effect_instance)

func _on_CoinGroupSpawnTimer_timeout():
	if do_spawn:
		spawn_coin_group()
		Events.emit_signal("update_timer", "coin_group_spawn", Utils.random_range([1, 4]))

func spawn_coin_group():
	var pattern = Utils.random_range([0, coin_patterns.size()])
	var coin_group_instance = coin_patterns[pattern].instance()
	self.get_child(0).add_child(coin_group_instance)

func _on_LifeSpawnTimer_timeout():
	var life_instance = life[0].instance()
	var spawn_index = Utils.random_range([1, 5])
	self.get_child(spawn_index).add_child(life_instance)
	
	Events.emit_signal("stop_timer", "life_spawn")

func _on_game_start():
	do_spawn = true
