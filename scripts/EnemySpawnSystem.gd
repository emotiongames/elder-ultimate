extends Node2D


var sidewalk_enemies = [
	preload("res://scenes/chapters/first/characters/enemies/contaminated-person/ContaminatedPerson.tscn")
]
var street_top_enemies = [
	preload("res://scenes/chapters/first/characters/enemies/vehicles/common/l-direction/Car.tscn"),
	preload("res://scenes/chapters/first/characters/enemies/vehicles/specials/l-direction/Police.tscn")
	]
var street_bottom_enemies = [
	preload("res://scenes/chapters/first/characters/enemies/vehicles/common/r-direction/Car.tscn"),
	preload("res://scenes/chapters/first/characters/enemies/vehicles/specials/r-direction/Police.tscn")
]

var do_spawn = false

var noise = OpenSimplexNoise.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 8.0
	noise.persistence = 0.8
	do_connections()


func do_connections():
	var _show_game_over_connection = Events.connect(
		"show_game_over",
		self,
		"_on_show_game_over"
	)
	var _game_start_connect = Events.connect(
		"game_start",
		self,
		"_on_game_start"
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func spawn_sidewalk_enemies():
	var available_spawns = [0, 6]
	var spawn_index = -1
	if Utils.get_noise(noise) >= 0:
		spawn_index = available_spawns[0]
	else:
		spawn_index = available_spawns[1]
	
	if self.get_child(spawn_index).get_child_count() == 0:
		var enemy_index = Utils.random_range([0, sidewalk_enemies.size()])
		var enemy = sidewalk_enemies[enemy_index]
		spawn_enemies(enemy, spawn_index)


func spawn_street_enemies():
	var available_spawns = [2, 5]
	var spawn_index = -1
	if Utils.get_noise(noise) >= 0:
		spawn_index = available_spawns[0]
	else:
		spawn_index = available_spawns[1]
	
	if self.get_child(spawn_index).get_child_count() == 0:
		if spawn_index % 2 == 0:
			var enemy_index = Utils.random_range([0, street_top_enemies.size()])
			var enemy = street_top_enemies[enemy_index]
			spawn_enemies(enemy, spawn_index)
		else:
			var enemy_index = Utils.random_range([0, street_bottom_enemies.size()])
			var enemy = street_bottom_enemies[enemy_index]
			spawn_enemies(enemy, spawn_index)


func spawn_enemies(enemy, spawn):
	var enemy_instance = enemy.instance()
	enemy_instance.set_from_spawn(spawn)
	self.get_child(spawn).add_child(enemy_instance)


func _on_show_game_over():
	do_spawn = false


func _on_SidewalkEnemySpawnTimer_timeout():
	if do_spawn:
		var timer = Utils.random_range([1, 3])
		
		spawn_sidewalk_enemies()
		Events.emit_signal("update_timer", "sidewalk_enemy_spawn", timer)


func _on_StreetEnemySpawnTimer_timeout():
	if do_spawn:
		var timer = Utils.random_range([4, 9])
		
		spawn_street_enemies()
		Events.emit_signal("update_timer", "street_enemy_spawn", timer)


func _on_game_start():
	do_spawn = true
