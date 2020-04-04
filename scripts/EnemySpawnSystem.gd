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

var do_spawn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var _show_game_over_connection = Events.connect("show_game_over", self, "_on_show_game_over")
	var _resume_game_connection = Events.connect("resume_game", self, "_on_resume_game")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func spawn_sidewalk_enemies():
	randomize()
	
	var spawn_orientation_index = int(rand_range(0, 4))
	var available_spawns = [0, 1, 6, 7]
	var spawn_index = available_spawns[spawn_orientation_index]
	if self.get_child(spawn_index).get_child_count() == 0:
		if spawn_index % 2 == 0:
			var enemy = sidewalk_enemies[int(rand_range(0, sidewalk_enemies.size()))]
			var bias = self.get_child(spawn_index + 1).position
			bias.x = self.get_child(spawn_index).position.x - bias.x
			spawn_enemies(enemy, spawn_index, -1, -bias)
		else:
			var enemy = sidewalk_enemies[int(rand_range(0, sidewalk_enemies.size()))]
			var bias = self.get_child(spawn_index - 1).position
			bias.x -= self.get_child(spawn_index).position.x
			spawn_enemies(enemy, spawn_index, 1, bias)

func spawn_street_enemies():
	randomize()
	var spawn_orientation_index = int(rand_range(0, 2))
	var available_spawns = [2, 5]
	var spawn_index = available_spawns[spawn_orientation_index]
	
	if self.get_child(spawn_index).get_child_count() == 0:
		if spawn_index % 2 == 0:
			var enemy = street_top_enemies[int(rand_range(0, street_top_enemies.size()))]
			var bias = self.get_child(spawn_index + 1).position
			bias.x = self.get_child(spawn_index).position.x - bias.x
			spawn_enemies(enemy, spawn_index, -1, -bias)
		else:
			var enemy = street_bottom_enemies[int(rand_range(0, street_bottom_enemies.size()))]
			var bias = self.get_child(spawn_index - 1).position
			bias.x -= self.get_child(spawn_index).position.x
			spawn_enemies(enemy, spawn_index, 1, bias)

func spawn_enemies(enemy, spawn, orientation, bias):
	var enemy_instance = enemy.instance()
	enemy_instance.set_orientation(orientation)
	enemy_instance.set_bias_position(bias)
	enemy_instance.set_from_spawn(spawn)
	self.get_child(spawn).add_child(enemy_instance)

func _on_show_game_over():
	do_spawn = false

func _on_resume_game():
	do_spawn = true

func _on_SidewalkEnemySpawnTimer_timeout():
	spawn_sidewalk_enemies()
	randomize()
	Events.emit_signal("update_timer", "sidewalk_enemy_spawn", int(rand_range(1, 4)))

func _on_StreetEnemySpawnTimer_timeout():
	spawn_street_enemies()
	randomize()
	Events.emit_signal("update_timer", "street_enemy_spawn", int(rand_range(1, 5)))
