extends BossAi

class_name ManagerAI

@export var attackArea : BossAttackArea

enum {CHASE, BASIC_ATTACK, PREPARE_SPECIAL, SPECIAL_ATTACK, STANDBY, STUNNED}

var state : int = STANDBY

const PAPER_ATTACK = preload("res://SRC/Enemies/Bosses/ManagerBoss/paper_attack.tscn")

var target : Player

func _ready() -> void:
	super()
	target = PlayerManager.player
	await get_tree().physics_frame
	attackHolder = Node3D.new()
	WorldManager.currentLevel.add_child(attackHolder)

func fightStart() -> void:
	state = CHASE

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
			if paperAttacks.size() == 0:
				spawnPaper()
			if stateTimer < 0.001:
				state = SPECIAL_ATTACK
				stateTimer = 5.0
		SPECIAL_ATTACK:
			stateTimer -= delta
			shootPaper()
			if stateTimer < 0.001:
				state = CHASE
				stateTimer = 8.0
		STUNNED:
			if boss.stunTime < 0.001:
				if prevState != PREPARE_SPECIAL:
					state = CHASE
				else:
					state = prevState

var prevState : int

@export var animTree : AnimationTree
func onAtkAreaDetected() -> void:
	if state == CHASE:
		animTree.onPlayerInRange()

const HPI : float = PI/2
var paperAttacks : Array[PaperAttack]
var attackHolder : Node3D
const attacks : float = 3
func spawnPaper() -> void:
	for i : int in range(attacks):
		var patk : PaperAttack = PAPER_ATTACK.instantiate()
		paperAttacks.append(patk)
		patk.instigator = boss
		patk.speed = 20.0
		attackHolder.add_child(patk)
		patk.position = Vector3()
		patk.rotation.y = ((i - (attacks / 2.0))/attacks) * (PI/4)
		patk.position.y += randf_range(-0.01,0.01)

func shootPaper() -> void:
	for p : PaperAttack in paperAttacks:
		if p and !p.is_queued_for_deletion():
			p.launch()
	paperAttacks.clear()

func purgePaper() -> void:
	for p : PaperAttack in paperAttacks:
		if p and !p.is_queued_for_deletion():
			p.queue_free()

func aiReaction(amount : int, instigator : Node3D, grabbable: GrabbableProp) -> void:
	boss.stunTime = clamp(0.2 * amount, 0.25, 1.0)
	prevState = state
	state = STUNNED
	purgePaper()
	boss.recoveryTime = 0.15
	boss.attackOnBoss(amount, instigator)

func aiDefeat() -> void:
	$"../CharacterRotator/Character/Armature/Skeleton3D/PhysicalBoneSimulator3D".physical_bones_start_simulation()
	if !PlayerManager.getKey("director"):
		PlayerManager.keys.append("director")
