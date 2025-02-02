extends Node3D

class_name PenAttack

@export var damage : int = 3
var instigator : Node3D
@export var circle : MeshInstance3D
@export var pen : Node3D
@export var damage_area: Area3D

var delay : float = 1.0

func setCol(col : Color) -> void:
	circle.material_override.albedo_color = col

func attack() -> void:
	var circleTween : Tween = create_tween()
	circleTween.finished.connect(onCircleFinish)
	circleTween.tween_property(circle.material_override,"albedo_color",Color.RED,delay)

func onCircleFinish() -> void:
	for b : Node3D in damage_area.get_overlapping_bodies():
		if b is Player:
			b.onDamaged(damage, instigator)
	circle.visible = false
	var penTween : Tween = create_tween()
	penTween.finished.connect(onPenFinished)
	penTween.tween_property(pen, "position:y", 2.7, 0.15)

func onPenFinished() -> void:
	await get_tree().create_timer(0.1).timeout
	var retractTween : Tween = create_tween()
	retractTween.finished.connect(onPenRetract)
	retractTween.tween_property(pen, "position:y", 0.0, 0.08)

func onPenRetract() -> void:
	queue_free()
