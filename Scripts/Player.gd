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

# hold the current state of the player's input
var input_state = {turn = false, bomb = false, fire = false}

func _process(delta):
	var velocity = Vector2()
	
	# set rotation depending on direction
	rotation = (PI / 2) * (direction - 2)
	
	# rotate character movement direction
	if input_state.turn:
		input_state.turn = false  # only turn once
		
		# turn the player
		direction += 1
		if direction > 4: direction = 1

	# calculate the velocity vector to move along
	velocity = Utils.get_vector_from_direction(direction) * movement_speed
	
	# actually move the player
	position += velocity

	# shoot a bullet
	if input_state.fire and not is_ghost:
		input_state.fire = false  # only fire once
		
		# setup bullet prefab and fire it
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
		main_game_scene_node.get_node('Bullets').add_child(instance)
		
		$FireSound.play()
	
	# fire a bomb
	if input_state.bomb and not is_ghost:
		input_state.bomb = false
		
		if Globals.bombs > 0:
			# kill all enemies
			for enemy in get_tree().get_nodes_in_group("Enemies"):
				enemy.queue_free()
				
				# increment score
				Globals.score += enemy.points_worth
			
			# decrement bomb count and trigger screen flash
			Globals.use_bomb()


func _input(event):
	# set new input state from the current event
	if event.is_action_pressed("key_c"):
		input_state.fire = true
	if event.is_action_pressed("key_z"):
		input_state.turn = true
	if event.is_action_pressed("key_x"):
		input_state.bomb = true

func _on_Player_area_entered(area):
	if area.is_in_group("Enemies") and not is_ghost:
		Globals.player_death()
