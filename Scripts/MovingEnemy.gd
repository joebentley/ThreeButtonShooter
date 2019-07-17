extends Sprite

export var movement_speed = 2
export var direction = 3  # 1 left 2 up 3 right 4 down

func _process(delta):
	var velocity = Utils.get_vector_from_direction(direction) * movement_speed
	position += velocity
