extends TextureRect

signal on_down
signal on_up

export var input_key = "key_z"

export (Texture) var pressed_texture
var up_texture

var pressed = false

func _ready():
	up_texture = texture

func on_down():
	$ButtonDownSound.play()
	texture = pressed_texture
	pressed = true
	emit_signal("on_down")
	
func on_up():
	$ButtonUpSound.play()
	texture = up_texture
	pressed = true
	emit_signal("on_up")
	
func _input(event):
	# when key pressed, simulate a mouse click on the button
	if event.is_action_pressed(input_key):
		on_down()
	elif event.is_action_released(input_key):
		on_up()

func _gui_input(event):
	if event.get_class() == "InputEventMouseButton" and event.button_index == BUTTON_LEFT:
		if event.pressed:
			on_down()
		else:
			on_up()