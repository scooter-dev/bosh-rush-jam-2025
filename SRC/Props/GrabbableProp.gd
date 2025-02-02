extends RigidBody3D

class_name GrabbableProp

##How much damage deals when going at 6 m/s
@export var damage : float = 1
##Weight class to compare to player strength
@export var weightClass : int = 1
##How many times can deal damage before breaking
@export var health : int = 5
@export var grabPoint : Node3D
##Chance to drop an item
@export var dropChance : float = 1.0
##Loot that it can drop
@export var lootTable : Array[LootEntry]


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
		if body is Zombie or body is BossZombie:
			var dmg : int = int(damage * prevVel.length() / 6.0)
			if dmg > 0:
				if body.onDamaged(dmg, thrower, self):
					health -= 1
					for i in range(int(PlayerManager.luck)):
						dropItem()
				if health == 0:
					die()
					return
	if linear_velocity.length_squared() < 4.0:
		tmr = max(0.0, tmr - delta)
		if tmr < 0.001:
			set_physics_process(false)
			deac.emit()
			thrower = null
	prevVel = linear_velocity

const PUFF_OF_SMOKE = preload("res://SRC/Effects/puff_of_smoke.tscn")
func die() -> void:
	var puff : CPUParticles3D = PUFF_OF_SMOKE.instantiate()
	WorldManager.currentLevel.add_child(puff)
	puff.global_position = global_position
	queue_free()

const ITEM_DROP = preload("res://SRC/Items/item_drop.tscn")
func dropItem() -> void:
	if lootTable.size() == 0:
		return
	
	if randf_range(0,1) > dropChance:
		return
	
	var drop : ItemDrop = ITEM_DROP.instantiate()
	
	var item : int
	var total : float = 0.0
	for l : LootEntry in lootTable:
		total += l.chance
	var rand : float = randf_range(0.0, total)
	var sum : float = 0.0
	for l : LootEntry in lootTable:
		var pSum = sum
		sum += l.chance
		if pSum < rand and sum >= rand:
			item = l.item
			break
	
	drop.item = item
	drop.velocity = Vector3(randf_range(-1,1),1,randf_range(-1,1)).normalized() * randf_range(2,6)
	WorldManager.currentLevel.add_child(drop)
	drop.global_position = global_position

func setCol() -> void:
	collision_layer = layer
	collision_mask = mask
	yCol.emit()

func setColDelay() -> void:
	await get_tree().create_timer(0.034).timeout
	collision_layer = layer
	collision_mask = mask
	yCol.emit()
