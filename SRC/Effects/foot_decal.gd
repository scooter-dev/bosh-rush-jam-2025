extends MeshInstance3D

class_name FootDecal

func fade(speed : float = 1.0) -> void:
	var tween : Tween = create_tween()
	tween.tween_property(material_override, "shader_parameter/albedo", Color(1,1,1,0), speed)
	await get_tree().create_timer(speed + 0.02).timeout
	queue_free()
