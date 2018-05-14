extends Node

#var startingLocation = Vector3(0.0, 0.0, 0.0);
#var worldObjects = [];
#var tileObject = load("res://Tile.tscn");
#var constructLib = load("res://items/Construction_MeshLibrary.meshlib");

const CELL_SIZE = 3.0  # Cell size in distance
export var grid_size = 128  # Grid size in cells

var grid = []
var preview_item = null  # PackedScene or null
var preview_node = null  # Object or null

func _ready():
	$HUD.connect("item_clicked", self, "handle_item_click")
	
	# Initialize empty grid
	for x in range(grid_size):
		grid.append([])
		for y in range(grid_size):
			grid[x].append(null)
	
func handle_item_click(item):
	var pos = Vector3()
	if preview_node:
		# Preserve last preview's position
		pos = preview_node.translation  # *Pretty sure* this is a getter that creates a new Vector3, Vector3 is otherwise mutable
		preview_node.queue_free()
		
	preview_item = item
	
	if item:
		preview_node = item.instance()
		preview_node.preview = true
		add_child(preview_node)
		preview_node.translation = pos
		
func snap_to_grid(pos):
	var new_pos = Vector3()
	new_pos[0] = CELL_SIZE * round(pos[0] / CELL_SIZE)
	new_pos[2] = CELL_SIZE * round(pos[2] / CELL_SIZE)
	return new_pos
	
func pos_to_coords(pos):
	var x = round(pos[0] / CELL_SIZE)
	var y = round(pos[2] / CELL_SIZE)
	return [x, y]
	
func coords_to_pos(coords):
	var pos = Vector3()
	pos[0] = coords[0] * CELL_SIZE
	pos[2] = coords[2] * CELL_SIZE
	return pos

func _unhandled_input(event):
	if(event is InputEventKey):
		# For testing/debugging only. Actual game defines these on item button nodes
		if(event.pressed and event.scancode == KEY_1):
			handle_item_click(preload("res://items/toilet.tscn"))
		if(event.pressed and event.scancode == KEY_2):
			handle_item_click(preload("res://items/sink.tscn"))
			
	# Preview rotation...
	if event.is_action_pressed("rotate_left"):
		pass
		
	elif event.is_action_pressed("rotate_right"):
		pass
		
	# Item placement
	if event.is_action_pressed("mouse1"):
		if preview_node:
			var coords = pos_to_coords(preview_node.translation)
			var x = coords[0]
			var y = coords[1]
			if (grid[x][y] == null):
				var node = preview_item.instance()
				node.translation = preview_node.translation
				node.register(self)
				assert(grid[x][y] == node)
				add_child(node)
				
	# Item removal
	if event.is_action_pressed("mouse2"):
		if preview_node:
			var coords = pos_to_coords(preview_node.translation)
			var x = coords[0]
			var y = coords[1]
			var node = grid[x][y]
			if (node != null):
				grid[x][y] = null
				node.queue_free()

func _process(delta):
	if preview_node:
		# Moves item preview to mouse position
		var mousepos = get_viewport().get_mouse_position()
		var start = $Camera.project_ray_origin(mousepos)
		var end = $Camera.project_ray_normal(mousepos) * 1000.0
		
		var state = $Camera.get_world().direct_space_state
		var result = state.intersect_ray(start, end)
		
		if result.size() > 0 and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:  # Captured = rotating camera
			preview_node.translation = snap_to_grid(result['position'])
