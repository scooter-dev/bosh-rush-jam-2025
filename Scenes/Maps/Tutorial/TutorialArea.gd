extends Area3D

@export_multiline var text : String :
	set(t):
		text = t
		if is_inside_tree():
			if get_overlapping_bodies().size() > 0:
				tutorialLabel.text = text
@export var tutorialLabel : Label

func _ready() -> void:
	body_entered.connect(bEntered)
	body_exited.connect(bExited)

func bEntered(body : Node3D) -> void:
	tutorialLabel.text = text

func bExited(body : Node3D) -> void:
	tutorialLabel.text = ""
