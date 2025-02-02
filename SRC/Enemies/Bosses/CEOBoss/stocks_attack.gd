extends Node3D

class_name StocksStrike

@export var damage : int = 3
var instigator : Node3D
@export var circle : MeshInstance3D
@export var stockArrow : Node3D
@export var damage_area: Area3D

var delay : float = 1.0

func setCol(col : Color) -> void:
	circle.material_override.albedo_color = col

func attack() -> void:
	var circleTween : Tween = create_tween()
	circleTween.finished.connect(onCircleFinish)
	circleTween.tween_property(circle.material_override,"albedo_color",Color.BLUE_VIOLET,delay)

func onCircleFinish() -> void:
	for b : Node3D in damage_area.get_overlapping_bodies():
		if b is Player:
			b.onDamaged(damage, instigator)
	circle.visible = false
	var arrowTween : Tween = create_tween()
	arrowTween.finished.connect(onStockCrash)
	arrowTween.tween_property(stockArrow, "position:y", 2.7, 0.15)

func onStockCrash() -> void:
	await get_tree().create_timer(0.1).timeout
	var retractTween : Tween = create_tween()
	retractTween.finished.connect(onStrikeFade)
	retractTween.tween_property(stockArrow, "position:y", 0.0, 0.08)

func onStrikeFade() -> void:
	queue_free()