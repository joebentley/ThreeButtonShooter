extends ColorRect

signal new_game

func _ready():
	$Score.text = "Final score: " + str(Globals.score)

func _input(event):
	if event.is_action_pressed("key_c"):
		emit_signal("new_game")
