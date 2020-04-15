extends CenterContainer


var do_shuffle = false
var effect_to_use = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	do_connections()
	pass # Replace with function body.


func do_connections():
	var _start_effect_shuffle_connect = Events.connect(
		"start_effect_shuffle",
		self, 
		"_on_start_effect_shuffle"
	)
	var _remove_effect_from_ui_connect = Events.connect(
		"remove_effect_from_ui",
		self,
		"_on_remove_effect_from_ui"
	)
	var _show_game_over_connection = Events.connect(
		"show_game_over",
		self,
		"_on_show_game_over"
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if do_shuffle:
		do_effect_roullete()


func do_effect_roullete():
	var index_to_show = Utils.random_range([0, self.get_child_count() - 1])
	var index_to_hide = 0
	self.get_child(index_to_show).show()
	
	while index_to_hide < self.get_child_count() - 1:
		if index_to_hide != index_to_show:
			self.get_child(index_to_hide).hide()
		index_to_hide = index_to_hide + 1


func _on_start_effect_shuffle(shuffle_until):
	do_shuffle = true
	match shuffle_until:
		"invencibility":
			effect_to_use = 0
		"reduce_speed":
			effect_to_use = 1
		"increase_speed":
			effect_to_use = 2
		"magnet":
			effect_to_use = 3
	Events.emit_signal("start_timer", "effect_shuffle")


func _on_remove_effect_from_ui():
	effect_to_use = -1
	var index = 0
	while index < self.get_child_count() - 1:
		self.get_child(index).hide()
		index = index + 1


func _on_ShuffleTimer_timeout():
	do_shuffle = false
	if effect_to_use != -1:
		self.get_child(effect_to_use).show()
	
		var index = 0
		while index < self.get_child_count() - 1:
			if index != effect_to_use:
				self.get_child(index).hide()
			index = index + 1
		Events.emit_signal("update_effect_state", "ready_to_use")


func _on_show_game_over():
	do_shuffle = false
	_on_remove_effect_from_ui()
