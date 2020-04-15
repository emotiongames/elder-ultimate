extends Node


signal player_damage(local)
signal player_invencibility(state)
signal player_magnet(state)
signal player_position_updated(position)

signal show_game_over
signal resume_game
signal count_point(point)
signal count_coin(value)
signal decrement_countdown

signal update_timer(label, value)
signal start_timer(label)
signal stop_timer(label)

signal show_main_menu
signal update_message_text(new_text)
signal life_increment
signal game_start

signal start_effect_behavior(label)
signal update_effect_state(state)
signal start_effect_shuffle(shuffle_until)
signal remove_effect_from_ui
signal scroll_speed_effect(action)
signal increase_scroll_speed
signal scroll_speed_updated(speed)
signal reduce_speed_done
signal run_effect

signal power_ended


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
