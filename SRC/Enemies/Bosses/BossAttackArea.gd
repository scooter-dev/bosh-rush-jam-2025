extends Area3D

class_name BossAttackArea

@export var boss : BossZombie

signal playerInRange

func _ready() -> void:
	set_process(false)
	body_entered.connect(detected)
	body_exited.connect(undetected)

@export var attackLaunched : bool = false
func detected(body : Node3D) -> void:
	set_process(true)

func _process(delta: float) -> void:
	if boss.isDead:
		return
	#print(attackLaunched)
	if !attackLaunched:
		attackLaunched = true
		playerInRange.emit()
		#print(attackLaunched)

func undetected(body : Node3D) -> void:
	if get_overlapping_bodies().size() == 0:
		set_process(false)

func attack() -> void:
	if boss.isDead:
		return
	for p : Player in get_overlapping_bodies():
		p.onDamaged(boss.boss_damage, boss)

func rearmAttakc() -> void:
	attackLaunched = false
