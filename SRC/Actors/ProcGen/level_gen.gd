extends Node3D

const PROC_CENTRAL_01 = preload("res://SRC/Actors/ProcGen/Pieces/proc_central_01.tscn")
const PROC_CENTRAL_02 = preload("res://SRC/Actors/ProcGen/Pieces/proc_central_02.tscn")

func _enter_tree() -> void:
	WorldManager.currentLevel = self

const rotations : Array[int] = [0, 90, 180, 270]
func _ready() -> void:
	
	var tile : ProceduralPiece = PROC_CENTRAL_01.instantiate() if randf_range(0,1) > 0.5 else PROC_CENTRAL_02.instantiate()
	var rot : int = rotations.pick_random()
	add_child(tile)
	tile.global_position.z = 20
	tile.global_rotation.y = deg_to_rad(rot)
	match rot:
		0:
			tile.b_zminus.queue_free()
			tile.b_xplus.queue_free()
		90:
			tile.b_xplus.queue_free()
			tile.b_zplus.queue_free()
		180:
			tile.b_zplus.queue_free()
			tile.b_xminus.queue_free()
		270:
			tile.b_xminus.queue_free()
			tile.b_zminus.queue_free()
	
	tile = PROC_CENTRAL_01.instantiate() if randf_range(0,1) > 0.5 else PROC_CENTRAL_02.instantiate()
	rot = rotations.pick_random()
	add_child(tile)
	tile.global_position.z = 20
	tile.global_position.x = 40
	tile.global_rotation.y = deg_to_rad(rot)
	match rot:
		0:
			tile.b_xminus.queue_free()
			tile.b_zplus.queue_free()
		90:
			tile.b_zminus.queue_free()
			tile.b_xminus.queue_free()
		180:
			tile.b_xplus.queue_free()
			tile.b_zminus.queue_free()
		270:
			tile.b_zplus.queue_free()
			tile.b_xplus.queue_free()
	
	tile = PROC_CENTRAL_01.instantiate() if randf_range(0,1) > 0.5 else PROC_CENTRAL_02.instantiate()
	rot = rotations.pick_random()
	add_child(tile)
	tile.global_position.z = 20 + 40
	tile.global_position.x = 40
	tile.global_rotation.y = deg_to_rad(rot)
	match rot:
		0:
			tile.b_zminus.queue_free()
			#tile.b_zminus.queue_free()
		90:
			tile.b_xplus.queue_free()
			#tile.b_xminus.queue_free()
		180:
			tile.b_zplus.queue_free()
			#tile.b_zplus.queue_free()
		270:
			tile.b_xminus.queue_free()
			#tile.b_xplus.queue_free()
