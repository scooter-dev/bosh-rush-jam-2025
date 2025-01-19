extends Node3D

class_name CharRotator

@export var player : Player

func _physics_process(delta: float) -> void:
	match player.mode:
		Player.COMBAT:
			if player.hSpeed > 0.2:
				global_rotation.y = lerp_angle(global_rotation.y, Vector2(player.velocity.z,player.velocity.x).angle() + PI, 16.0 * delta)
		Player.GRABBING:
			pass
