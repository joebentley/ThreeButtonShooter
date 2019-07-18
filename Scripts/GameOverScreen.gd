extends ColorRect

signal new_game

func _input(event):
	if event.is_action_pressed("key_c"):
		# stop the input from triggering other scenes
		get_tree().set_input_as_handled()
		
		emit_signal("new_game")
