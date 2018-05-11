extends Node

var startingLocation = Vector3(0.0, 0.0, 0.0);
var worldObjects = [];
var tileObject = load("res://Tile.tscn");
var constructLib = load("res://assets/Construction_MeshLibrary.meshlib");

var toilet = load("res://assets/plumbing/Toilet/Toilet.tscn");
var sink = load("res://assets/plumbing/Toilet/Toilet.tscn");

var constructContainer = [];
var currentSelection;
var lastSelection;

var cursorObject;

func _ready():
	BuildGrid();
	Construct();
	pass

func BuildGrid():
	var node = tileObject.instance();
	self.add_child(node);
	
	for x in range(100):
		worldObjects.append([]);
		for y in range(100):
			worldObjects[x].append(null);
			
	pass
	
func Construct():
	var wall = constructLib.get_item_mesh(0); #wall chnk
	var corner = constructLib.get_item_mesh(1); #corner chnk
	
	var toilet = plumbingLib.get_item_mesh(0); #toilet chnk
	var sink = plumbingLib.get_item_mesh(1); #sink chnk
	
	constructContainer.append(toilet);
	constructContainer.append(sink);
	
	if(currentSelection == null):
		currentSelection = constructContainer[0];
		lastSelection = constructContainer[0];
	pass

func _input(event):
	
	if(event is InputEventKey):
		if(event.pressed and event.scancode == KEY_1):
			currentSelection = constructContainer[0];
		if(event.pressed and event.scancode == KEY_2):
			currentSelection = constructContainer[1];
		print(currentSelection);
	
	pass

func _process(delta):
	if(currentSelection != lastSelection):
		lastSelection = currentSelection;
		var tempNode = 
		cursorObject = currentSelection.instance();
		self.add_child(cursorObject);
	
	if(cursorObject != null):
		var mouse_position = get_viewport().get_mouse_position();
		cursorObject.position = mouse_position;
	
	pass
