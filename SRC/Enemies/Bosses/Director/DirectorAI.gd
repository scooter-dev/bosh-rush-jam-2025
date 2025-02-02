extends BossAi

class_name DirectorAI

@export var attackArea : BossAttackArea

enum {CHASE, BASIC_ATTACK, PREPARE_SPECIAL, SPECIAL_ATTACK, STANDBY}

var state : int = STANDBY

const AREA_ATTACK = preload("res://SRC/Enemies/Bosses/Director/area_attack.tscn")

var target : Player

func _ready() -> void:
	super()
	target = PlayerManager.player
	await get_tree().physics_frame
	attackHolder = Node3D.new()
	WorldManager.currentLevel.add_child(attackHolder)
	state = CHASE

func activate() -> void:
	pass

var stateTimer : float = 8.0

func aiTick(delta : float) -> void:
	if boss.isDead:
		attackHolder.queue_free()
		state = STANDBY
		set_physics_process(false)
	var dir : Vector3 = (target.global_position - boss.global_position)
	if state != STANDBY:
		boss.desired_rotation = -Vector2(dir.x, dir.z).angle() - HPI
	match state:
		STANDBY:
			pass
		CHASE:
			stateTimer -= delta
			boss.targetPosition = target.global_position
			if stateTimer < 0.001:
				stateTimer = 2.0
				state = PREPARE_SPECIAL
				boss.targetPosition = boss.global_position
		PREPARE_SPECIAL:
			stateTimer -= delta
			if attackHolder:
				attackHolder.global_position = boss.global_position
				attackHolder.global_rotation.y = boss.desired_rotation
			if attacks1.size() == 0:
				spawnAreadDamage()
			if stateTimer < 0.001:
				state = SPECIAL_ATTACK
				stateTimer = 4.0
		SPECIAL_ATTACK:
			stateTimer -= delta
			fireAreaDamage()
			if stateTimer < 0.001:
				state = CHASE
				stateTimer = 8.0

@export var animTree : AnimationTree
func onAtkAreaDetected() -> void:
	if state == CHASE:
		animTree.onPlayerInRange()

const HPI : float = PI/2
var attacks1 : Array[PenAttack]
var attacks2 : Array[PenAttack]
var attackHolder : Node3D

const atkSize : int = 11

func spawnAreadDamage() -> void:
	for i : int in range(atkSize):
		for j : int in range(atkSize):
			if (i + j * atkSize) % 2 == 0:
				continue
			var atk : PenAttack = AREA_ATTACK.instantiate()
			attacks1.append(atk)
			atk.instigator = boss
			atk.setCol(Color.ORANGE)
			WorldManager.currentLevel.add_child(atk)
			atk.global_position = boss.global_position + (Vector3(i % atkSize,0, j) - Vector3(atkSize / 2,0,atkSize / 2)) * 1.5
			atk.position.y += randf_range(-0.01,0.01)
	for i : int in range(atkSize):
		for j : int in range(atkSize):
			if (i + j * atkSize) % 2 != 0:
				continue
			var atk : PenAttack = AREA_ATTACK.instantiate()
			atk.setCol(Color.GREEN_YELLOW)
			atk.delay = 1.7
			attacks2.append(atk)
			atk.instigator = boss
			WorldManager.currentLevel.add_child(atk)
			atk.global_position = boss.global_position + (Vector3(i % atkSize,0, j) - Vector3(atkSize / 2,0,atkSize / 2)) * 1.5
			atk.position.y += randf_range(-0.01,0.01)

func fireAreaDamage() -> void:
	if attacks1.size() > 0:
		for atk : PenAttack in attacks1:
			atk.attack()
		attacks1.clear()
		for atk : PenAttack in attacks2:
			atk.attack()
		attacks2.clear()

func aiReaction(amount : int, instigator : Node3D, grabbable: GrabbableProp) -> void:
	boss.recoveryTime = 0.15
	boss.attackOnBoss(amount, instigator)

@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $"../RotatorNode/Character/Armature/Skeleton3D/PhysicalBoneSimulator3D"

func aiDefeat() -> void:
	physical_bone_simulator_3d.physical_bones_start_simulation()
	PlayerManager.keys
