extends Area2D

export var movement_speed = 3
var direction = 2 # 1 2 3 4 left up right down

export (PackedScene) var bullet_prefab
export (NodePath) var main_game_scene = "/root/Window/Game/ClippingRectangle"

# whether or not the player is a ghost ship (via screenwrap)
var is_ghost = false

# main game scene to add bullet to
var main_game_scene_node

func _ready():
	main_game_scene_node = get_node(main_game_scene)
	
	# use parent node if main_game_scene_node couldn't be found
	if main_game_scene_node == null:
		main_game_scene_node = get_node("..")


func _process(delta):
	var velocity = Vector2()
	
	# set rotation depending on direction
	rotation = (PI / 2) * (direction - 2)
	
	# pause the character if holding x
	if not Input.is_action_pressed("key_x"):
		# rotate character movement direction
		if Input.is_action_just_pressed("key_z"):
			direction += 1
			if direction > 4: direction = 1
	
		# calculate the velocity vector to move to
		velocity = Utils.get_vector_from_direction(direction) * movement_speed
		
		position += velocity
	
		# shoot a bullet
		if Input.is_action_just_pressed("key_c") and not is_ghost:
			var instance = bullet_prefab.instance()
			instance.direction = direction
			
			# approximate relative location of players turret when pointing left
			var offset = Vector2(-scale.y * 2, 0)
			# rotate bullet offset for each player rotation relative to left
			for i in range(direction - 1):
				offset = offset.rotated(PI / 2)
			
			# set the bullet position
			instance.position = position + offset
			# add it as a child of the main game scene
			main_game_scene_node.add_child(instance)
			
			$FireSound.play()