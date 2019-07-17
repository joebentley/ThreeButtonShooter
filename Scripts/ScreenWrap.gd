extends Control

export (PackedScene) var prefab
export var initialPosition = Vector2()

var instance
var ghosts = []
var screen_size

func _ready():
	instance = prefab.instance()
	add_child(instance)
	
	instance.position = initialPosition
	
	# generate the ghost entities
	for i in range(8):
		var ghost = prefab.instance()
		add_child(ghost)
		ghosts.append(ghost)
		ghost.is_ghost = true

# set the ghost positions
func position_ghosts():
	ghosts[0].position = instance.position + Vector2(-screen_size.x, 0)
	ghosts[1].position = instance.position + Vector2(-screen_size.x, -screen_size.y)
	ghosts[2].position = instance.position + Vector2(0, -screen_size.y)
	ghosts[3].position = instance.position + Vector2(screen_size.x, -screen_size.y)
	ghosts[4].position = instance.position + Vector2(screen_size.x, 0)
	ghosts[5].position = instance.position + Vector2(screen_size.x, screen_size.y)
	ghosts[6].position = instance.position + Vector2(0, screen_size.y)
	ghosts[7].position = instance.position + Vector2(-screen_size.x, screen_size.y)
	
	for ghost in ghosts:
		ghost.rotation = instance.rotation

# swap with ghost if needed
func swap_with_ghost():
	if instance.position.y < 0:  # swap with bottom
		instance.position = ghosts[6].position
	elif instance.position.y > screen_size.y:  # swap with top
		instance.position = ghosts[1].position
	if instance.position.x < 0:  # swap with right
		instance.position = ghosts[4].position
	elif instance.position.x > screen_size.x:  # swap with left
		instance.position = ghosts[0].position
	
	position_ghosts()

func _process(delta):
	# get current size of the element, to use as bounds for screen wrap
	# we do it each frame to make sure we get the full size after all parents
	# have been positioned
	screen_size = get_size()
	
	swap_with_ghost()
