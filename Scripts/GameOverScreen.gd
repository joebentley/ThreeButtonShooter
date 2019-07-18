extends ColorRect

signal new_game

func _input(event):
	if event.is_action_pressed("key_z"):
		emit_signal("new_game")
