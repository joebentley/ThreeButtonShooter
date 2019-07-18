extends Node

var score = 0

var game_over_screen = preload('res://Scenes/GameOverScreen.tscn')
var game = preload('res://Scenes/Game.tscn')

func player_death():
	var instance = game_over_screen.instance()
	instance.connect("new_game", self, "_new_game")

	get_node('/root/Window/Game').queue_free()
	get_node('/root/Window').add_child(instance)

# restart the game, setting score to zero
func _new_game():
	score = 0
	
	var instance = game.instance()
	
	get_node('/root/Window/GameOverScreen').queue_free()
	get_node('/root/Window').add_child(instance)
