@tool
extends MeshInstance3D

@export var item : VMItem :
	set(i):
		item = i
		if is_inside_tree():
			update()
@export_category("Components")
@export var label: Label3D


func _ready() -> void:
	update()

func update() -> void:
	if item:
		match item.item:
			PlayerManager.e_items.GLUE:
				label.text = "Glue"
			PlayerManager.e_items.STAPLES:
				label.text = "Iron Staples"
			PlayerManager.e_items.TAPE:
				label.text = "Tape"
			PlayerManager.e_items.PHONE_BOOK:
				label.text = "Phone Book"
			PlayerManager.e_items.SODA:
				label.text = "Soda"
			PlayerManager.e_items.CANDY:
				label.text = "Energy Bar\nRecovers health."
			PlayerManager.e_items.TUBING:
				label.text = "Tubing"
			PlayerManager.e_items.WIRES:
				label.text = "Wires"
			PlayerManager.e_items.CHIP:
				label.text = "Electronic Chip"
			PlayerManager.e_items.CIRCUIT_BOARD:
				label.text = "Circuit Board"
			PlayerManager.e_items.PEN:
				label.text = "Pen"
			PlayerManager.e_items.LASER_POINTER:
				label.text = "Laser Pointer\nAllows for easier aiming."
		label.text += "\nPrice: %d" % item.price
		label.text = "Code: %d\n" % item.code + label.text
	else:
		label.text = ""
