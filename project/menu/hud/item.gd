extends TextureButton

export(PackedScene) var item
export(Texture) var icon
export var enabled = false

func _ready():
	if enabled:
		texture_normal = icon