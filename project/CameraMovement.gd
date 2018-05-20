extends Camera

func _ready():
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_A:
				MoveLateral(-1)
			if event.scancode == KEY_D:
				MoveLateral(1)
			if event.scancode == KEY_W:
				MoveLong(1)
			if event.scancode == KEY_S:
				MoveLong(-1)
			if event.scancode == KEY_SPACE:
				MoveVertical(1)
			if event.scancode == KEY_CONTROL:
				MoveVertical(-1)
				
func MoveLateral(var direction):
	if direction > 0:
		translate(get_transform().basis.xform(Vector3(1.0, 0.0, 0.0)))
	else:
		translate(get_transform().basis.xform(Vector3(-1.0, 0.0, 0.0)))

func MoveLong(var direction):
	if direction > 0:
		translate(get_transform().basis.xform(Vector3(0.0, 0.0, 1.0)))
	else:
		translate(get_transform().basis.xform(Vector3(0.0, 0.0, -1.0)))

func MoveVertical(var direction):
	if direction > 0:
		translate(get_transform().basis.xform(Vector3(0.0, -1.0, 0.0)))
	else:
		translate(get_transform().basis.xform(Vector3(0.0, 1.0, 0.0)))