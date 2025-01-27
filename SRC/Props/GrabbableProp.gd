extends RigidBody3D

class_name GrabbableProp

@export var damage : float = 1
@export var weightClass : int = 1
@export var grabPoint : Node3D


@onready var mask : int = collision_mask
@onready var layer : int = collision_layer

var thrower : Node3D = null

enum DamageType {ELECTRIC, WATER, FIRE, CAT}

func _ready() -> void:
	set_physics_process(false)


signal noCol
signal yCol
signal deac
func setNoCol() -> void:
	collision_layer = 0
	collision_mask = 0
	noCol.emit()

func thrown(thrwr : Node3D) -> void:
	thrower = thrwr
	tmr = 1.0
	setColDelay()
	contact_monitor = true
	max_contacts_reported = 4
	set_physics_process(true)

var tmr : float = 0.0
var prevVel : Vector3 = Vector3()
func _physics_process(delta: float) -> void:
	for body : Node in get_colliding_bodies():
		if body is Zombie:
			var dmg : int = int(damage * prevVel.length() / 6.0)
			if dmg > 0:
				body.onDamaged(dmg, thrower, self)
	if linear_velocity.length_squared() < 4.0:
		tmr = max(0.0, tmr - delta)
		if tmr < 0.001:
			set_physics_process(false)
			deac.emit()
			thrower = null
	prevVel = linear_velocity


func setCol() -> void:
	collision_layer = layer
	collision_mask = mask
	yCol.emit()

func setColDelay() -> void:
	await get_tree().create_timer(0.034).timeout
	collision_layer = layer
	collision_mask = mask
	yCol.emit()
