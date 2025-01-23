extends Node3D

class_name DamageNSpawner

const DAMAGE_NUMBER = preload("res://SRC/Enemies/damage_number.tscn")

func spawnDNumber(damage : int) -> void:
	var dn : DamageNumber = DAMAGE_NUMBER.instantiate()
	
	dn.setLabel(str(damage))
	WorldManager.currentLevel.add_child(dn)
	dn.global_position = global_position
