extends Node3D

class_name PlayerCamera

@export var cam_x: Node3D


func _physics_process(delta: float) -> void:
	rotate_y(-PlayerInput.l_udrl.x)
	cam_x.rotation.x = clamp(cam_x.rotation.x - PlayerInput.l_udrl.y, -PI/2, PI/2)
