extends RigidBody3D

class_name Zombie

@export var startHealth : int = 10
@export var speed : float = 10
@export_category("Components")
@export var anim_tree: AnimationTree
@export var damage_number_spawner: DamageNSpawner
@export var health_bar: HealthBar

var health : int = 10

var target : Node3D = null

func _ready() -> void:
	health = startHealth
	health_bar.setHealthRelative(float(health)/float(startHealth))
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	recoveryTime = max(0, recoveryTime - delta)
	pass

func _on_detection_area_player_detected(player: Player) -> void:
	if !target:
		target = player
		set_physics_process(true)

var recoveryTime = 0.0
func onDamaged(damage : int ,instigator : Node3D = null) -> void:
	if recoveryTime < 0.005:
		recoveryTime = 0.2
		if instigator:
			if instigator is Player:
				target = instigator
		health -= damage
		damage_number_spawner.spawnDNumber(damage)
		health_bar.setHealthRelative(float(health)/float(startHealth))
		if health <= 0:
			die()

func die() -> void:
	set_physics_process(false)
