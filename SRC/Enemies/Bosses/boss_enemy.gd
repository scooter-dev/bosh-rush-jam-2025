extends RigidBody3D

class_name BossZombie

@export var boss_health: float
@export var damage_number_spawner: DamageNSpawner
@export var foot_decal: FootDecal
@export var nav_agent: NavigationAgent3D
@export var rotatorNode: Node3D

signal dead
signal damaged(amount : int, instigator : Node3D, grabbable: GrabbableProp)

# var nav_enable: bool = false
var isDead : bool = false
var health : int = 10
var recoveryTime : float = 0.00
var invulnerable: bool = true

var speed: float = 200
var desired_rotation: float = 0.00

var targetPosition : Vector3 = Vector3()
var spawnPosition : Vector3

func _ready():
	targetPosition = global_position

func _physics_process(_delta):
	if getPlanarDistanceToTargetSq() > 1:
		nav_agent.target_position = targetPosition
		var next_position: Vector3 = nav_agent.get_next_path_position()
		apply_central_force((next_position-global_position)* Vector3(1,0,1) * speed)
	#rotatorNode.global_rotation.y = desired_rotation
	

func getPlanarDistanceToTargetSq():
	return ((targetPosition - global_position)  * Vector3(1,0,1)).length_squared()

func onDamaged(damage : int ,instigator : Node3D = null, grabbable : GrabbableProp = null) -> void:
	if recoveryTime < 0.005:
		damaged.emit(damage, instigator, grabbable)

func attackOnBoss(damage : int ,instigator : Node3D = null) -> void:
	if recoveryTime < 0.005:
		
		health -= damage
		damage_number_spawner.spawnDNumber(damage)
		if health <= 0:
			die()
		

func die() -> void:
	isDead = true
	dead.emit()
	set_physics_process(false)
	lock_rotation = false
	linear_damp = 0.1
	physics_material_override.friction = 0.4
	collision_layer = 0
	collision_mask = 0
	freeze = true
	foot_decal.fade()
