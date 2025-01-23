extends MeshInstance3D

class_name HealthBar

func setHealthRelative(h : float) -> void:
	material_override.set_shader_parameter("fill", clamp(h,0,1))
