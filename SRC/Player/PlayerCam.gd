extends Node3D

class_name PlayerCamera

@export var player : Player
@export var camera : Camera3D
@export var camX : Node3D


func _physics_process(delta: float) -> void:
	if player.playerEnabled:
		rotate_y(PlayerInput.l_udrl.x)
