extends Control

export (PackedScene) var enemy_prefab

# inital time between enemies
export var time_between_enemy = 2
# after this many enemies, make the time between spawns shorter
export var num_enemies_between_level = 100 
# make spawn time shorter by this number of seconds every num_enemies_between_level enemies
export var time_harder_every_level = 0.2
# shortest time between enemy spawn, can't go below this
export var minimum_time_between_enemy = 1

# padding around the spawn area
export var padding = 20
# size of spawn area
export var extent = 100
# whether or not spawner is initially enabled
export var enabled = true
# time to wait to enable the spawner
export var time_until_enabled = 0

# spawn a new enemy in a random place outside the viewport
func spawn_enemy():
	var screen_size = {x = get_size().x as int, y = get_size().y as int}
	
	# 1 left 2 up 3 right 4 down
	var direction = randi() % 4 + 1
	var rand_x
	var rand_y
	
	# TODO: I think this is broken right now
	
	# generate a random position in the rectangle going past the screen boundary
	# we also flip the direction which will become the movement direction for the enemy
	if direction == 1:
		rand_y = randi() % (screen_size.y - 2 * padding) + padding
		rand_x = -(randi() % extent) - padding
		direction = 3
	elif direction == 2:
		rand_x = randi() % (screen_size.x - 2 * padding) + padding
		rand_y = -(randi() % extent) - padding
		direction = 4
	elif direction == 3:
		rand_y = randi() % (screen_size.y - 2 * padding) + padding
		rand_x = randi() % extent + padding + screen_size.x
		direction = 1
	elif direction == 4:
		rand_x = randi() % (screen_size.x - 2 * padding) + padding
		rand_y = randi() % extent + padding + screen_size.y
		direction = 2
	
	var instance = enemy_prefab.instance()
	instance.position = Vector2(rand_x, rand_y)
	instance.direction = direction
	add_child(instance)


var time_elapsed_since_last_enemy = 0
var enemies_spawned_this_level = 0

func _process(delta):
	if enabled:
		# if we have spawned enough enemies, shorten time between enemy spawn
		if enemies_spawned_this_level > num_enemies_between_level:
			enemies_spawned_this_level = 0
			time_between_enemy -= time_harder_every_level
			
			# never go below the minimum time
			if time_between_enemy < minimum_time_between_enemy:
				time_between_enemy = minimum_time_between_enemy
		
		time_elapsed_since_last_enemy += delta
		
		# spawn enemy after enough time passed
		if time_elapsed_since_last_enemy > time_between_enemy:
			time_elapsed_since_last_enemy = 0
			spawn_enemy()
			enemies_spawned_this_level += 1
	else:
		# enable spawner after time_until_enable passed
		time_until_enabled -= delta
		if time_until_enabled < 0:
			enabled = true