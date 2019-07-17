extends Node

# 1 left 2 up 3 right 4 down
func get_vector_from_direction(direction):
	if direction == 1:
		return Vector2(-1, 0)
	elif direction == 2:
		return Vector2(0, -1)
	elif direction == 3:
		return Vector2(1, 0)
	elif direction == 4:
		return Vector2(0, 1)
	else:
		return null