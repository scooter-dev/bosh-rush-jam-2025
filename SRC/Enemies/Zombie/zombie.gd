extends RigidBody3D

class_name Zombie

@export var startHealth : int = 10
@export var speed : float = 8
@export var damage : int = 3

##How long the zombie chases the player when losing sight
@export var memory : float = 4.0
@export_category("Components")
@export var anim_tree: AnimationTree
@export var damage_number_spawner: DamageNSpawner
@export var health_bar: HealthBar
@export var nav_agent: NavigationAgent3D
@export var boneSimulator : PhysicalBoneSimulator3D
signal dead
signal damaged(amount : int, instigator : Node3D, grabbable: GrabbableProp)

var isDead : bool = false

var health : int = 10

var target : Node3D = null
var spawnPosition : Vector3

func _ready() -> void:
	spawnPosition = global_position
	wanderPos = spawnPosition
	health = startHealth
	health_bar.setHealthRelative(float(health)/float(startHealth))

var nTargTimer : float = 0.0

enum {WANDERING, CHASING, LOSING, RETURNING}
var mode : int = WANDERING
func sMode() -> void:
	match mode:
		RETURNING:
			if target:
				mode = CHASING
			elif chaseTarget:
				mode = LOSING
			elif ((global_position - spawnPosition) * Vector3(1,0,1)).length_squared() < 1:
				mode = WANDERING
		WANDERING:
			if target:
				mode = CHASING
			elif chaseTarget:
				mode = LOSING
			elif ((global_position - spawnPosition) * Vector3(1,0,1)).length_squared() > 25:
				mode = RETURNING
		CHASING:
			if !target:
				if chaseTarget:
					mode = LOSING
				else:
					mode = WANDERING
		LOSING:
			if target:
				mode = CHASING
			elif !chaseTarget:
				mode = WANDERING

var wanderPos : Vector3
var wanderWait : float = 0.0
func _physics_process(delta: float) -> void:
	sMode()
	recoveryTime = max(0, recoveryTime - delta)
	stunTimer = max(0, stunTimer - delta)
	if stunTimer > 0.005:
		return
	match mode:
		WANDERING:
			#$Label3D.text = "WANDERING"
			if ((global_position - wanderPos) * Vector3(1,0,1)).length_squared() < 1.0:
				if wanderWait > 0.005:
					wanderWait = max(wanderWait - delta, 0)
				else:
					wanderPos = global_position + Vector3(randf_range(-3,3),0,randf_range(-3,3))
					wanderWait = randf_range(1.0, 12.0)
			else:
				nav_agent.target_position = wanderPos
				var nextPos : Vector3 = nav_agent.get_next_path_position()
				apply_central_force(((nextPos - global_position) * Vector3(1,0,1)).normalized() * speed * 4.0)
		RETURNING:
			#$Label3D.text = "RETURNING"
			nav_agent.target_position = spawnPosition
			var nextPos : Vector3 = nav_agent.get_next_path_position()
			apply_central_force(((nextPos - global_position) * Vector3(1,0,1)).normalized() * speed * 5.0)
			if (global_position * Vector3(1,0,1)).distance_squared_to(spawnPosition * Vector3(1,0,1)) < 1.0:
				mode = WANDERING
		CHASING:
			#$Label3D.text = "CHASING"
			if target:
				nav_agent.target_position = target.global_position
				var nextPos : Vector3 = nav_agent.get_next_path_position()
				apply_central_force(((nextPos - global_position) * Vector3(1,0,1)).normalized() * speed * 10.0)
		LOSING:
			#$Label3D.text = "LOSING"
			if chaseTarget:
				nav_agent.target_position = chaseTarget.global_position
				var nextPos : Vector3 = nav_agent.get_next_path_position()
				apply_central_force(((nextPos - global_position) * Vector3(1,0,1)).normalized() * speed * 10.0)
				chaseTime = max(0, chaseTime - delta)
				if chaseTime < 0.005:
					nTargTimer = 6.0
					chaseTarget = null
	#$Label3D.text = str(target.name if target else "null") + "\n" + $Label3D.text

func _on_detection_area_player_detected(player: Player) -> void:
	if !target:
		target = player
		set_physics_process(true)

var recoveryTime : float = 0.0
var stunTimer : float = 0.0
func onDamaged(damage : int ,instigator : Node3D = null, grabbable: GrabbableProp = null) -> bool:
	if recoveryTime < 0.005:
		recoveryTime = 0.2
		if instigator:
			if instigator is Player:
				target = instigator
		health -= damage
		health_bar.visible = true
		stunTimer = float(damage) * 0.25
		damage_number_spawner.spawnDNumber(damage)
		health_bar.setHealthRelative(float(health)/float(startHealth))
		damaged.emit(damage, instigator, grabbable)
		if health <= 0:
			die()
		return true
	return false


@export var living_shape: CollisionShape3D
@export var foot_decal: FootDecal


func die() -> void:
	isDead = true
	dead.emit()
	set_physics_process(false)
	living_shape.disabled = true
	#dead_shape.disabled = false
	#dead_shape_2.disabled = false
	lock_rotation = false
	linear_damp = 0.1
	physics_material_override.friction = 0.4
	collision_layer = 0
	collision_mask = 0
	freeze = true
	boneSimulator.physical_bones_start_simulation()
	health_bar.queue_free()
	foot_decal.fade()

var chaseTime : float = 0.0
var chaseTarget : Node3D = null
func _on_detection_area_lost_player(player: Player) -> void:
	if player == target:
		chaseTarget = target
		target = null
		chaseTime = memory
