extends CanvasLayer

signal item_clicked

func _ready():
	var buttons = []
	find_item_buttons(buttons, get_children())

func find_item_buttons(buttons, children):
	for c in children:
		find_item_buttons(buttons, c.get_children())
		if c.get("item"):  # Quack
			c.connect("pressed", self, "item_button_pressed", [c])
			
func item_button_pressed(button):
	print("CHANGE ITEM SELECTION HERE")
	print(button.item)
	emit_signal("item_clicked", button.item)