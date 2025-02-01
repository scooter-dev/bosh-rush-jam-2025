extends CPUParticles3D


func _ready() -> void:
	await get_tree().physics_frame
	emitting = true

func _on_finished() -> void:
	queue_free()
