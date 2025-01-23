extends Node3D

class_name DamageNumber

@export var riseCurve : Curve
@export var riseTime : float = 3.0
@export var riseAmount : float = 2.0

@export var label: Label3D

func setLabel(text : String) -> void:
	label.text = text

func _ready() -> void:
	tmr = 0.0

var tmr : float = 0.0
func _process(delta: float) -> void:
	tmr += delta
	label.position.y = riseCurve.sample_baked(clamp(tmr, 0, riseTime) / riseTime) * riseAmount
	if tmr > riseTime - 0.005:
		queue_free()
