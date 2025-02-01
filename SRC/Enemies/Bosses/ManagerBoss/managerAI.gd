extends BossAi

enum {CHASE, BASIC_ATTACK, PREPARE_SPECIAL, SPECIAL_ATTACK}

var state : int

const PAPER_ATTACK = preload("res://SRC/Enemies/Bosses/ManagerBoss/paper_attack.tscn")


var target : Player

func _ready() -> void:
	super()
	target = PlayerManager.player
	await get_tree().create_timer(0.5).timeout
	spawnPaper()
	await get_tree().create_timer(1.0).timeout
	shootPaper()

func aiTick() -> void:
	match state:
		CHASE:
			return
			boss.targetPosition = target.global_position
			if boss.global_position.distance_squared_to(target.global_position) < 2:
				state = BASIC_ATTACK
		BASIC_ATTACK:
			pass
		PREPARE_SPECIAL:
			pass
		SPECIAL_ATTACK:
			pass

const HPI : float = PI/2
var paperAttacks : Array[PaperAttack]

func spawnPaper() -> void:
	var dir : Vector3 = (target.global_position - boss.global_position)
	var dRot : float = Vector2(dir.x,dir.z).angle() - HPI
	for i : int in range(5):
		var patk : PaperAttack = PAPER_ATTACK.instantiate()
		paperAttacks.append(patk)
		WorldManager.currentLevel.add_child(patk)
		patk.global_position = boss.global_position
		patk.global_rotation.y = dRot + ((i - 1.5)/5.0) * (PI/3)
		patk.global_position.y += randf_range(-0.01,0.01)

func shootPaper() -> void:
	for p : PaperAttack in paperAttacks:
		p.launch()
	paperAttacks.clear()

func aiReaction(amount : int, instigator : Node3D, grabbable: GrabbableProp) -> void:
	
	boss.attackOnBoss(amount, instigator)

func aiDefeat() -> void:
	pass
