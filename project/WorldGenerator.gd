extends Node

var startingLocation = Vector3(0.0, 0.0, 0.0);
var worldObjects = [];
var tileObject = load("res://Tile.tscn");
#var constructLib = load("res://assets/Construction_MeshLibrary.meshlib");

var toiletObj = load("res://items/plumbing/Toilet/Toilet.tscn");
var sinkObj = load("res://items/plumbing/Sink/Sink.tscn");

var objContainer = [];
var currentSelection;
var lastSelection;

var cursorObject;

func _ready():
	BuildGrid();
	Construct();

func BuildGrid():
	var node = tileObject.instance();
	self.add_child(node);
	
	for x in range(100):
		worldObjects.append([]);
		for y in range(100):
			worldObjects[x].append(null);

func Construct():
	ConstructEnvironment();
	PlayerConstruction();

func ConstructEnvironment():
	#var wall = constructLib.get_item_mesh(0); #wall chnk
	#var corner = constructLib.get_item_mesh(1); #corner chnk
	pass

func PlayerConstruction():
	var toilet = toiletObj; #toilet chnk
	objContainer.push_back(toilet);
	
	var sink = sinkObj; #sink chnk
	objContainer.push_back(sink);
	
	if(currentSelection == null):
		currentSelection = objContainer[0];
		lastSelection = objContainer[0];

func _input(event):
	
	if(event is InputEventKey):
		if(event.pressed and event.scancode == KEY_1):
			currentSelection = objContainer[0];
		if(event.pressed and event.scancode == KEY_2):
			currentSelection = objContainer[1];
		print(currentSelection);


func _process(delta):
	if(currentSelection != lastSelection):
		lastSelection = currentSelection;
		cursorObject = currentSelection.instance();
		self.add_child(cursorObject);
	
	if(cursorObject != null):
		var mouse_position = get_viewport().get_mouse_position();
		
		var ray_dist = 1000
		var camera = get_node("Camera")
		var start = camera.project_ray_origin(mouse_position)
		var end = start + camera.project_ray_normal(mouse_position) * ray_dist
		var space_state = camera.get_world().direct_space_state
		var result = space_state.intersect_ray(start, end)
		
		
		
		if result.size() > 0 and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			cursorObject.translation = result["position"];