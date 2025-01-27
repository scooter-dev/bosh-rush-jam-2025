extends Area3D

class_name InteractionArea

signal interacted(instigator : Node3D)

func onInteracted(instigator : Node3D) -> void:
	interacted.emit(instigator)
