extends "res://Scripts/MovingEnemy.gd"

func _ready():
	if direction == 2:
		$EnemySprite.rotation = PI / 2
	elif direction == 3:
		$EnemySprite.flip_h = true
	elif direction == 4:
		$EnemySprite.rotation = 3 * PI / 2
