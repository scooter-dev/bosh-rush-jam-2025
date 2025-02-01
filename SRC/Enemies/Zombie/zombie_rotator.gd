extends Node3D

@export var zombie : Zombie

func _process(delta: float) -> void:
	if zombie.isDead:
		set_process(false)
	
	const hPI = PI/2
	if zombie.target:
		var dir : Vector3 = (zombie.target.global_position - global_position)
		global_rotation.y = lerp_angle(global_rotation.y, hPI -Vector2(dir.x,dir.z).angle(), delta * 6.0)
	elif zombie.linear_velocity.length_squared() > 0.1:
		global_rotation.y = lerp_angle(global_rotation.y, hPI -Vector2(zombie.linear_velocity.x,zombie.linear_velocity.z).angle(), delta * 6.0)
