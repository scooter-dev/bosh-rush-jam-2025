extends RigidBody3D

class_name GrabbableProp

@onready var mask : int = collision_mask
func setNoCol() -> void:
	collision_layer = 0
	collision_mask = 0

func setCol() -> void:
	collision_layer = 4
	collision_mask = mask

func setColDelay() -> void:
	await get_tree().create_timer(0.034).timeout
	collision_layer = 4
	collision_mask = mask
