extends Node3D

class_name PaperAttack

@export var damage : int = 5
@export var speed : float = 6.0
@export var arrow : Node3D
@export var instigator : Node3D
@export var paperProjectile : Node3D
@export var ray : RayCast3D
@export var foot_decal: FootDecal


func _ready() -> void:
	ray.add_exception(instigator)
	ray.target_position.z = -speed * 1.1 * get_physics_process_delta_time()
	set_physics_process(false)

func launch() -> void:
	arrow.visible = false
	set_physics_process(true)

var lifetime : float = 10.0
func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime < 0.001:
		die()
		return
	var collider : Node3D = ray.get_collider()
	if collider:
		if collider is Player:
			collider.onDamaged(damage, instigator)
		if collider is Zombie:
			collider.onDamaged(damage, instigator, null)
		die()
		return
	ray.target_position.z = -speed * delta * 1.1
	global_position -= global_basis.z * delta * speed

const PAPERSPLOSION = preload("res://SRC/Effects/Papersplosion.tscn")

func die() -> void:
	foot_decal.reparent(WorldManager.currentLevel)
	foot_decal.fade(0.25)
	var pspl : Node3D = PAPERSPLOSION.instantiate()
	WorldManager.currentLevel.add_child(pspl)
	pspl.global_position = global_position
	set_physics_process(false)
	queue_free()
