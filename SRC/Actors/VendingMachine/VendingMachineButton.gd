@tool

extends MeshInstance3D

class_name VendingMachineButton

enum e_num {ZERO = 0, ONE = 1, TWO = 2, THREE = 3, FOUR = 4, FIVE = 5, SIX = 6, SEVEN = 7, EIGHT = 8, NINE = 9, ACCEPT = 10, CANCEL = -1}

@export var number : e_num = e_num.ONE : set = setNumber


func setNumber(n) -> void:
		number = n
		match number:
			e_num.ZERO:
				label.text = "0"
				material_override.set_shader_parameter("topColor", Color.LIGHT_GRAY)
			e_num.ONE:
				label.text = "1"
				material_override.set_shader_parameter("topColor", Color.LIGHT_GRAY)
			e_num.TWO:
				label.text = "2"
				material_override.set_shader_parameter("topColor", Color.LIGHT_GRAY)
			e_num.THREE:
				label.text = "3"
				material_override.set_shader_parameter("topColor", Color.LIGHT_GRAY)
			e_num.FOUR:
				label.text = "4"
				material_override.set_shader_parameter("topColor", Color.LIGHT_GRAY)
			e_num.FIVE:
				label.text = "5"
				material_override.set_shader_parameter("topColor", Color.LIGHT_GRAY)
			e_num.SIX:
				label.text = "6"
				material_override.set_shader_parameter("topColor", Color.LIGHT_GRAY)
			e_num.SEVEN:
				label.text = "7"
				material_override.set_shader_parameter("topColor", Color.LIGHT_GRAY)
			e_num.EIGHT:
				label.text = "8"
				material_override.set_shader_parameter("topColor", Color.LIGHT_GRAY)
			e_num.NINE:
				label.text = "9"
				material_override.set_shader_parameter("topColor", Color.LIGHT_GRAY)
			e_num.ACCEPT:
				label.text = "A"
				material_override.set_shader_parameter("topColor", Color.GREEN)
			e_num.CANCEL:
				label.text = "C"
				material_override.set_shader_parameter("topColor", Color.RED)


@export var left : VendingMachineButton
@export var right : VendingMachineButton
@export var up : VendingMachineButton
@export var down : VendingMachineButton
@export_category("Components")
@export var label: Label3D
@export var highlightMesh: MeshInstance3D

func _ready() -> void:
	setNumber(number)

func highlight() -> void:
	highlightMesh.visible = true

func unhighlight() -> void:
	highlightMesh.visible = false
