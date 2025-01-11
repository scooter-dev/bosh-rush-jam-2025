extends Node3D

class_name GroundRays

var ground : Node3D = null
var groundDistance : float = 50.0
var groundNormal : Vector3 = Vector3.UP

func _ready() -> void:
	if multiplayer.get_unique_id() != get_multiplayer_authority():
		queue_free()

const angleLimit : float = cos(deg_to_rad(40))

func _physics_process(delta: float) -> void:
	ground = null
	groundDistance = 50.0
	groundNormal = Vector3.UP
	for ray : RayCast3D in get_children():
		if ray.get_collider():
			var gDist : float = global_position.y - ray.get_collision_point().y
			var gNorm : Vector3 = ray.get_collision_normal()
			if gDist < groundDistance and gNorm.dot(Vector3.UP) > angleLimit:
				groundDistance = gDist
				groundNormal = gNorm
