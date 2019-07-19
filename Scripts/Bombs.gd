extends HBoxContainer

export (PackedScene) var bomb_prefab

func _ready():
	Globals.connect("bombs_changed", self, "render_bombs")
	render_bombs()

# add all the bombs to UI on change
func render_bombs():
	# remove all children nodes
	for child in get_children():
		child.queue_free()
	
	var bombs = Globals.bombs
	
	for i in range(bombs):
		add_child(bomb_prefab.instance())
