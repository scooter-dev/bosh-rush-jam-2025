extends MeshInstance3D

class_name NumPanel

@export var label: Label3D

signal cancel

var busy : bool = false

func addNum(num : int) -> void:
	if busy:
		return
	if label.text.length() < 3:
		label.text += str(num)

func cancelPressed() -> bool:
	if busy:
		return false
	if label.text.length() == 0:
		return true
	label.text = ""
	return false

func acceptPressed(code : int) -> void:
	if busy:
		return
	match code:
		0:
			label.text = "OK"
		1:
			label.text = "ERR"
		2:
			label.text = "$$$"
	busy = true
	await get_tree().create_timer(0.7).timeout
	label.text = ""
	busy = false

func getNumber() -> int:
	if label.text != "" and label.text.is_valid_int():
		return label.text.to_int()
	return -1
