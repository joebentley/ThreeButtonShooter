extends TextureButton

export var inputKey = "key_z"

func _pressed():
	# simulate key press on click
	Input.action_press(inputKey)

func _on_Button_button_down():
	$ButtonDownSound.play()

func _on_Button_button_up():
	$ButtonUpSound.play()

# to press the button in code we simulate a mouse click event
func simulate_click(pressed):
	var event = InputEventMouseButton.new()
	event.set_button_index(1)
	event.position = rect_global_position
	event.pressed = pressed
	Input.parse_input_event(event)

func _input(event):
	# when key pressed, simulate a mouse click on the button
	if event.is_action_pressed(inputKey):
		call_deferred("simulate_click", true)
	elif event.is_action_released(inputKey):
		call_deferred("simulate_click", false)
