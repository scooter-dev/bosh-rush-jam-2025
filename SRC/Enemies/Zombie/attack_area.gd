extends Area3D

class_name ZombieAttackArea

@export var zombie : Zombie

@onready var damage : int = zombie.damage

signal playerInArea

@export var attackCalled : bool = false

func _ready() -> void:
	set_physics_process(false)
	body_entered.connect(onBodyEntered)
	body_exited.connect(onBodyExited)

func onBodyEntered(body : Node3D) -> void:
	set_physics_process(true)

func onBodyExited(body : Node3D) -> void:
	if get_overlapping_bodies().size() == 0:
		set_physics_process(false)

signal dealtDamage
func doDamage() -> void:
	for player : Player in get_overlapping_bodies():
		player.onDamaged(zombie.damage, self)
	dealtDamage.emit()

func _physics_process(delta: float) -> void:
	if !attackCalled and !zombie.isDead:
		attackCalled = true
		playerInArea.emit()
		print("atk called")
		await get_tree().create_timer(1.0).timeout
		attackCalled = false
