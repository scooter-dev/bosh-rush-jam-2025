extends Area3D

signal playerDetected(player : Player)

var playersInRange : Array[Player]
var target : Node3D = null

var ray : PhysicsRayQueryParameters3D

func _ready() -> void:
	ray = PhysicsRayQueryParameters3D.new()
	ray.collision_mask = 3

func _physics_process(delta: float) -> void:
	for P : Player in playersInRange:
		ray.from = global_position
		ray.to = P.global_position + Vector3(0,1,0)
		var res : Dictionary = get_world_3d().direct_space_state.intersect_ray(ray)
		if res.has("collider"):
			if res.collider == P:
				playerDetected.emit(P)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		playersInRange.append(body)
		set_physics_process(true)

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		playersInRange.erase(body)
