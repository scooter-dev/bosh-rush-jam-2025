extends BossAi

class_name CeoAi

@export var attackArea : BossAttackArea

enum {CHASE, BASIC_ATTACK, PREPARE_SPECIAL, SPECIAL_ATTACK, STANDBY}

var state : int = STANDBY

const PAPER_ATTACK = preload("res://SRC/Enemies/Bosses/ManagerBoss/paper_attack.tscn")


var target : Player

func _ready() -> void:
	super()
	target = PlayerManager.player
	state = CHASE
	await get_tree().physics_frame
	# attackHolder = Node3D.new()
	# WorldManager.currentLevel.add_child(attackHolder)

func activate() -> void:
	pass