extends BossAi

class_name CeoAi

@export var attackArea : BossAttackArea
@export var animTree : AnimationTree

enum {CHASE, BASIC_ATTACK, PREPARE_SPECIAL, SPECIAL_ATTACK, STANDBY}
var state : int = STANDBY

const HPI : float = PI/2
var target : Player

func _ready() -> void:
	super()
	target = PlayerManager.player
	await get_tree().physics_frame

func activate() -> void:
	pass

var stateTimer : float = 8.0

func aiTick(delta : float) -> void:
	if boss.isDead:
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
		SPECIAL_ATTACK:
			stateTimer -= delta
			stocksStrike()
			if stateTimer < 0.001:
				state = CHASE
				stateTimer = 8.0

func stocksStrike():
	# initiate the special attack
	pass


func aiReaction(amount : int, instigator : Node3D, grabbable: GrabbableProp) -> void:
	boss.recoveryTime = 0.15
	boss.attackOnBoss(amount, instigator)

func aiDefeat() -> void:
	$"../CharacterRotator/Character/Armature/Skeleton3D/PhysicalBoneSimulator3D".physical_bones_start_simulation()
	PlayerManager.keys.append("rooftop")

func fightStart() -> void:
	state = CHASE
