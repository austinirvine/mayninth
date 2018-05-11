extends Node

export(PackedScene) var first_scene

func _ready():
	get_tree().change_scene_to(first_scene)
