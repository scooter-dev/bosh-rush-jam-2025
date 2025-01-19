extends CharacterBody3D

class_name Player

@export var cam : PlayerCamera

var acceleration : float = 160.0
var damping : float = 30.0

func _physics_process(delta: float) -> void:
	velocity = get_real_velocity()
	var dir : Vector3 = cam.global_basis.x * PlayerInput.fbrl.x + cam.global_basis.z * PlayerInput.fbrl.y
	dir = dir.limit_length()
	
	if is_on_floor():
		velocity.x -= velocity.x * delta * damping
		velocity.z -= velocity.z * delta * damping
		velocity += dir * delta * acceleration
	else:
		velocity.y = clamp(velocity.y - 9.8 * delta, -60,60)
	
	move_and_slide()
