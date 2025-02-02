extends BossAi

class_name CeoAi

@export var attackArea: BossAttackArea
@export var animTree: AnimationTree

enum {CHASE, BASIC_ATTACK, PREPARE_SPECIAL, SPECIAL_ATTACK, STANDBY}
var state: int = STANDBY
var stateTimer: float = 8.0

const HPI: float = PI / 2
var target: Player

var attackHolder : Node3D

const AREA_ATTACK = preload("res://SRC/Enemies/Bosses/CEOBoss/stocks_attack.tscn")

func _ready() -> void:
	super()
	target = PlayerManager.player
	await get_tree().physics_frame
	attackHolder = Node3D.new()
	WorldManager.currentLevel.add_child(attackHolder)

func fightStart() -> void:
	state = CHASE

func aiTick(delta: float) -> void:
	if boss.isDead:
		attackHolder.queue_free()
		state = STANDBY
		set_physics_process(false)
	var dir: Vector3 = (target.global_position - boss.global_position)
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
				aimAtPlayer()
			if stateTimer < 0.001:
				state = SPECIAL_ATTACK
				stateTimer = 5.0
		SPECIAL_ATTACK:
			stateTimer -= delta
			stocksStrike()
			if stateTimer < 0.001:
				state = CHASE
				stateTimer = 8.0

var attacks1: Array[StocksStrike]
var attacks2: Array[StocksStrike]
const atkSize: int = 10

#Place aim on player.
func aimAtPlayer():
	for i: int in range(atkSize):
		for j: int in range(atkSize):
			if (i + j * atkSize) % 2 == 0:
				continue
			var atk: StocksStrike = AREA_ATTACK.instantiate()
			attacks1.append(atk)
			atk.instigator = boss
			atk.setCol(Color.ORANGE)
			WorldManager.currentLevel.add_child(atk)
			atk.global_position = boss.global_position + (Vector3(i % atkSize, 0, j) - Vector3(atkSize / 2, 0, atkSize / 2)) * 3
			atk.position.y += randf_range(-0.01, 0.01)
	for i: int in range(atkSize):
		for j: int in range(atkSize):
			if (i + j * atkSize) % 2 != 0:
				continue
			var atk: StocksStrike = AREA_ATTACK.instantiate()
			atk.setCol(Color.GREEN_YELLOW)
			atk.delay = 1.7
			attacks2.append(atk)
			atk.instigator = boss
			WorldManager.currentLevel.add_child(atk)
			atk.global_position = boss.global_position + (Vector3(i % atkSize, 0, j) - Vector3(atkSize / 2, 0, atkSize / 2)) * 3
			atk.position.y += randf_range(-0.01, 0.01)

# initiate the special attack
func stocksStrike():
	if attacks1.size() > 0:
		for atk: StocksStrike in attacks1:
			atk.attack()
		attacks1.clear()
		for atk: StocksStrike in attacks2:
			atk.attack()
		attacks2.clear()

var prevState: int
func aiReaction(amount: int, instigator: Node3D, grabbable: GrabbableProp) -> void:
	if state != PREPARE_SPECIAL or state != SPECIAL_ATTACK:
		boss.stunTime = clamp(0.2 * amount, 0.25, 1.0)
		prevState = state
		# state = STUNNED
	boss.recoveryTime = 0.15
	boss.attackOnBoss(amount, instigator)


func aiDefeat() -> void:
	$"../CharacterRotator/Character/Armature/Skeleton3D/PhysicalBoneSimulator3D".physical_bones_start_simulation()
	PlayerManager.keys.append("rooftop")
