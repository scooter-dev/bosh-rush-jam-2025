extends Node3D

class_name Door

@export var locked : bool = false
@export var key : String
@export_category("Components")
@export var door_l: RigidBody3D
@export var door_r: RigidBody3D

func _ready() -> void:
	if locked:
		lock()

func _on_unlock_area_body_entered(body: Node3D) -> void:
	if PlayerManager.getKey(key) and !lockOverride:
		unlock()

func unlock() -> void:
	lockOverride = false
	locked = false
	door_l.freeze = false
	door_r.freeze = false
	door_l.collision_layer = 32
	door_r.collision_layer = 32

var lockOverride : bool = false
func lock(override : bool = false) -> void:
	lockOverride = override
	locked = true
	door_l.collision_layer = 33
	door_r.collision_layer = 33
	door_l.freeze = true
	door_r.freeze = true
	door_l.rotation = Vector3()
	door_r.rotation = Vector3()
