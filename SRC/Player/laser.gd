extends RayCast3D

@export var laserBegin: Node3D

func _physics_process(delta: float) -> void:
	if visible and get_collider():
		var dist : float = get_collision_point().distance_to(global_position)
		dist = max(dist,1.0)
		laserBegin.scale = Vector3(dist,dist,dist)
