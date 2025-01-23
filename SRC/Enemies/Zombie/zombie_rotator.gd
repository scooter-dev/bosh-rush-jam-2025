extends Node3D

@export var zombie : Zombie

func _process(delta: float) -> void:
	if zombie.isDead:
		set_process(false)
	
	const hPI = PI/2
	
	if zombie.linear_velocity.length_squared() > 0.1:
		global_rotation.y = lerp_angle(global_rotation.y, hPI -Vector2(zombie.linear_velocity.x,zombie.linear_velocity.z).angle(), delta * 6.0)
