extends CharacterBody3D

class_name Player

@export var cam : PlayerCamera

var acceleration : float = 160.0
var damping : float = 30.0

enum {COMBAT, GRABBING}

var mode : int = COMBAT
var grabbed : Node3D
var turnSpeed : float = 1.0
var hSpeed : float = 0.0

func _physics_process(delta: float) -> void:
	velocity = get_real_velocity()
	hSpeed = velocity.length()
	var dir : Vector3 = cam.global_basis.x * PlayerInput.fbrl.x + cam.global_basis.z * PlayerInput.fbrl.y
	dir = dir.limit_length()
	
	match mode:
		COMBAT:
			if is_on_floor():
				velocity.x -= velocity.x * delta * damping
				velocity.z -= velocity.z * delta * damping
				velocity += dir * delta * acceleration
			else:
				velocity.y = clamp(velocity.y - 9.8 * delta, -60,60)
		GRABBING:
			if is_on_floor():
				velocity.x -= velocity.x * delta * damping
				velocity.z -= velocity.z * delta * damping
				velocity += dir * delta * acceleration * 0.3
			else:
				velocity.y = clamp(velocity.y - 9.8 * delta, -60,60)
			pass
	
	move_and_slide()
