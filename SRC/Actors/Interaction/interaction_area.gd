extends Area3D

class_name InteractionArea

signal interacted(instigator : Node3D)
signal sel(col : Color)
signal unsel

func onInteracted(instigator : Node3D) -> void:
	interacted.emit(instigator)

func selected(col : Color = Color.GREEN) -> void:
	sel.emit(col)

func unselected() -> void:
	unsel.emit()
