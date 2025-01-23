extends Area3D

signal playerDetected(player : Player)
signal lostPlayer(player : Player)

var detectedPlayers : Array[Player]
var playersInRange : Array[Player]
var playersSeen : Array[Player]
var target : Node3D = null

var ray : PhysicsRayQueryParameters3D

func _ready() -> void:
	ray = PhysicsRayQueryParameters3D.new()
	ray.collision_mask = 3

func _physics_process(delta: float) -> void:
	for P : Player in detectedPlayers:
		ray.from = global_position
		ray.to = P.global_position + Vector3(0,1,0)
		var res : Dictionary = get_world_3d().direct_space_state.intersect_ray(ray)
		var foundPlayer : bool = false
		if res.has("collider"):
			if res.collider == P:
				if !playersSeen.has(P):
					playerDetected.emit(P)
				foundPlayer = true
		if !foundPlayer:
			if playersSeen.has(P):
				playersSeen.erase(P)
				if !playersInRange.has(P):
					detectedPlayers.erase(P)
			lostPlayer.emit(P)
		

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		playersInRange.append(body)
		detectedPlayers.append(body)
		set_physics_process(true)

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		if !playersSeen.has(body):
			detectedPlayers.erase(body)
		playersInRange.erase(body)


func _on_zombie_dead() -> void:
	queue_free()
