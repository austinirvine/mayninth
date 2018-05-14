extends MeshInstance

var registered = false
var preview = false

func _ready():
	# If placed in editor: Register on next frame.
	# In-game placement is registered immediately
	if !registered and !preview:
		call_deferred("register")
	
func register(parent=null):
	registered = true
	
	# This kinda makes me puke a little, but it lets us place items directly from the editor...
	if parent == null:
		parent = get_parent()
		
	var coords = parent.pos_to_coords(translation)
	var x = coords[0]
	var y = coords[1]
	assert(parent.grid[x][y] == null)
	parent.grid[x][y] = self