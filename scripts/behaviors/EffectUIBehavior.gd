extends CenterContainer

var do_shuffle = false
var effect_to_use = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	var _start_effect_shuffle_connect = Events.connect("start_effect_shuffle", self, "on_start_effect_shuffle")
	var _use_effect_connect = Events.connect("use_effect", self, "on_use_effect")
	pass # Replace with function body.

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

func on_start_effect_shuffle(shuffle_until):
	do_shuffle = true
	match shuffle_until:
		"invencibility": effect_to_use = 0
		"reduce_speed": effect_to_use = 1
	Events.emit_signal("start_timer", "effect_shuffle")

func on_use_effect(_effect):
	effect_to_use = -1
	if do_shuffle:
		do_shuffle = false
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
