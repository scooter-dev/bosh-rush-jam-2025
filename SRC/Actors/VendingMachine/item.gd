extends Node3D

class_name VMItem

@export var code : int
@export var item : PlayerManager.e_items
@export var price : int = 10
@export var showRotation : Vector3
@export var offset : Vector3

var mesh : Mesh

func _ready() -> void:
	mesh = get_child(0).mesh

func buy() -> bool:
	var hasItemsLeft : bool = false
	for c : Node3D in get_children():
		if c.visible:
			hasItemsLeft = true
			c.visible = false
			break
	return hasItemsLeft
