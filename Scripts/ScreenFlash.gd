extends ColorRect

func _ready():
	Globals.connect("screen_flash", self, "_screen_flash")

var timer = 0
const max_timer = 30

func _screen_flash():
	timer = max_timer

func _process(delta):
	color.a = 0
	
	if timer > 0:
		if timer == max_timer or timer == max_timer - 20 or timer == max_timer - 29:
			$BombSound.play()
			color.a = 1
		
		timer -= 1