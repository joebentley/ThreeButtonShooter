extends Area2D

export var speed = 8
export var direction = 3  # 1 is left, 2 is up, 3 is right, 4 is down

onready var hit_sound = get_node("/root/Window/EnemyHitSound")

func _ready():
	if direction == 1 or direction == 3:
		rotation = PI / 2
	else:
		rotation = 0
		
	connect("area_entered", self, "_on_area_entered")

func _process(delta):
	var velocity = Vector2()
	
	if direction == 1:
		velocity.x = -speed
	elif direction == 2:
		velocity.y = -speed
	elif direction == 3:
		velocity.x = speed
	elif direction == 4:
		velocity.y = speed
	
	position += velocity
	
	# free when off screen
	var screen_size = get_node("..").get_size()
	if position.x < -10 or position.x > screen_size.x + 10 \
	or position.y < -10 or position.y > screen_size.y + 10:
		queue_free()


func _on_Bullet_area_entered(area):
	if area.is_in_group("Enemies"):
		# play enemy hit sound, if it exists
		if hit_sound:
			hit_sound.play()
		
		# increment score
		Globals.score += area.points_worth
		
		# destroy this and the enemy
		area.queue_free()
		queue_free()
