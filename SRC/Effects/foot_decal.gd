extends MeshInstance3D

class_name FootDecal

func fade() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(material_override, "shader_parameter/albedo", Color(1,1,1,0), 1.0)
	await get_tree().create_timer(1.1).timeout
	queue_free()
