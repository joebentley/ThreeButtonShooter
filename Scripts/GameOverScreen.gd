extends ColorRect

const start_screen = preload("res://Scenes/StartScreen.tscn")

onready var high_score_file = Globals.high_score_file

var scores = []

func _ready():
	$Score.text = "Final score: " + str(Globals.score)
	
	# check if it's a high score
	var file = File.new()
	file.open(high_score_file, File.READ_WRITE)
	
	# Each line is of the format "XYZ 1234" (intials then score).
	# The scores should already be sorted in descending order.
	
	# We check if we have a high score by seeing if we are higher than
	# any of the first 5 scores.
	
	var i = 0
	var high_score = false
	scores = []
	
	# TODO: it is redundant to keep track of i (num of scores read)
	# here, because we only ever save 5 max
	while not file.eof_reached() and i < 5:
		var line = file.get_line()
		
		if len(line) == 0:
			continue
		
		# increment number of scores seen
		i += 1
		
		# parse the line
		var name_and_score = line.split(' ')
		scores.append([name_and_score[0], int(name_and_score[1])])
		
		# if our score is higher than any of these scores, we have a high score
		if Globals.score > int(name_and_score[1]):
			high_score = true
	
	file.close()
	
	if high_score:
		_prompt_high_score()

class ScoreSorter:
	static func sort(a, b):
		if a[1] > b[1]:
			return true
		return false


var high_score_cursor_index = 0
var high_score_prompt = false

func _prompt_high_score():
	$GameOver.text = "High score!!"
	$HighScoreInput.visible = true
	$Restart.visible = false
	high_score_prompt = true

func _save_high_score(initials):
	# add high score
	scores.append([initials, Globals.score])
	scores.sort_custom(ScoreSorter, "sort")

	# drop all scores that have fallen off end (should just be one)
	while len(scores) > 5:
		scores.pop_back()
	
	# overwrite file with new highscores
	var file = File.new()
	file.open(high_score_file, File.WRITE)
	
	for score in scores:
		file.store_line(score[0] + ' ' + str(score[1]))
	
	file.close()

func _do_input_action_at_current_cursor_position():
	if high_score_cursor_index < 3:
		# get the text node
		var node = get_node("HighScoreInput/Initial" + str(high_score_cursor_index + 1))
		assert node != null
		
		# increment letter for node
		if node.text == "Z":
			node.text = "A"
		else:
			# increment the letter by converting to ascii, adding one, and converting back
			node.text = PoolByteArray([node.text.ord_at(0) + 1]).get_string_from_ascii()
	
	if high_score_cursor_index == 3:
		var string = ""
		
		# gather initials from the labels
		for i in range(3):
			var node = get_node("HighScoreInput/Initial" + str(i + 1))
			assert node != null
			string += node.text
		
		_save_high_score(string)
		
		# TODO: make a start screen showing high scores
		
		$HighScoreInput.visible = false
		$Restart.visible = true
		high_score_prompt = false

func _input(event):
	if high_score_prompt:
		if high_score_cursor_index > 0 and event.is_action_pressed("key_z"):
			# move cursor to left
			high_score_cursor_index -= 1
			$HighScoreInput/Arrow.position -= Vector2(20, 0)
		elif high_score_cursor_index < 3 and event.is_action_pressed("key_c"):
			# move cursor to right
			high_score_cursor_index += 1
			$HighScoreInput/Arrow.position += Vector2(20, 0)
		elif event.is_action_pressed("key_x"):
			_do_input_action_at_current_cursor_position()
	elif event.is_action_pressed("key_c"):
		# switch to the start screen
		var window = get_node('..')
		window.add_child_below_node(window.get_node('Buttons'), start_screen.instance())
		queue_free()
