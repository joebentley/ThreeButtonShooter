extends ColorRect

const game_scene = preload("res://Scenes/Game.tscn")

func _ready():
	var high_score_text = _load_high_scores()
	var high_scores = _split_scores_into_two_lists(high_score_text)
	
	# join the score arrays into one string 
	high_scores[0] = PoolStringArray(high_scores[0]).join('\n')
	high_scores[1] = PoolStringArray(high_scores[1]).join('\n')
	
	$HighScoresNames.text = high_scores[0]
	$HighScores.text = high_scores[1]

# parse and return all high scores
func _load_high_scores():
	var file = File.new()
	file.open(Globals.high_score_file, File.READ)
	
	var scores = []
	
	# read and parse all scores from file
	while not file.eof_reached():
		var line = file.get_line()
		if len(line) == 0:
			continue
		
		var name_and_score = line.split(' ')
		scores.append(name_and_score)
	
	return scores

# split the full list of score pairs into two lists
# [[name, score]] -> [[name], [score]]
func _split_scores_into_two_lists(names_and_scores):
	var names = []
	var scores = []
	
	for score in names_and_scores:
		names.append(score[0])
		scores.append(score[1])
	
	return [names, scores]

func _input(event):
	if event.is_action_pressed("key_c"):
		var window = get_node('..')
		var game = game_scene.instance()
		
		# reset the game variables
		Globals.new_game()
		
		# switch to the new scene
		queue_free()
		window.add_child(game)