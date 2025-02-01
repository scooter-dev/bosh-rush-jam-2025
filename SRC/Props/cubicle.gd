@tool

extends Node3D

@export var hasPrinter : bool = true:
	set(p):
		hasPrinter = p
		update()
@export var hasChair : bool = true:
	set(c):
		hasChair = c
		update()
@export var hasLeft : bool = true:
	set(l):
		hasLeft = l
		update()
@export var hasRight : bool = true:
	set(r):
		hasRight = r
		update()
@export var hasBack : bool = true:
	set(b):
		hasBack = b
		update()
@export_category("Components")
@export var printer : GrabbableProp
@export var chair : GrabbableProp
@export var separator_right : Node3D
@export var separator_left : Node3D
@export var separator_back : Node3D

func _ready() -> void:
	update()

func update() -> void:
	if !is_inside_tree():
		return
	if Engine.is_editor_hint():
		printer.visible = hasPrinter
		chair.visible = hasChair
		separator_right.visible = hasRight
		separator_left.visible = hasLeft
		separator_back.visible = hasBack
	else:
		for c : Node3D in get_children():
			if !c.visible:
				c.queue_free()
		
		if !hasPrinter:
			printer.queue_free()
		if !hasChair:
			chair.queue_free()
		if !hasRight:
			separator_right.queue_free()
		if !hasLeft:
			separator_left.queue_free()
		if !hasBack:
			separator_back.queue_free()
