extends Node

const high_score_file = "user://highscores.txt"

signal bombs_changed
signal screen_flash

var score = 0
var bombs = 3

var game_over_screen = preload('res://Scenes/GameOverScreen.tscn')
var game = preload('res://Scenes/Game.tscn')

func player_death():
	var instance = game_over_screen.instance()
	instance.connect("new_game", self, "_new_game")

	get_node('/root/Window/Game').queue_free()
	get_node('/root/Window').add_child(instance)


func new_game():
	score = 0
	bombs = 3

# set number of bombs and emit signal to update on-screen bomb count	
func set_bombs(value):
	if bombs > 0:
		bombs = value
		emit_signal("bombs_changed")

func use_bomb():
	set_bombs(bombs - 1)
	
	# trigger screen flash
	emit_signal("screen_flash")