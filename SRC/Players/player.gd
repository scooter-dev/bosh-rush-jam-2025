extends CharacterBody3D

class_name Player

var isLocal : bool = false

func _enter_tree() -> void:
	isLocal = multiplayer.get_unique_id() == get_multiplayer_authority()
