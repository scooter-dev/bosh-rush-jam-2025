extends Control

func _ready() -> void:
	await get_tree().create_timer(0.25)
	get_tree().change_scene_to_file(WorldManager.toLoad)
