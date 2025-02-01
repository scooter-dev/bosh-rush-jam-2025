extends Node

var fbrl : Vector2
var ml_udrl : Vector2
var l_udrl : Vector2

signal interact
signal jump
signal primary
signal secondary
signal back
signal SWL
signal SWR

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		ml_udrl = event.relative

func _physics_process(delta: float) -> void:
	l_udrl = Input.get_vector("L_L","L_R","L_D","L_U",0.2) * OptionsManager.controllerSensitivity + ml_udrl * OptionsManager.mouseSensitivity
	
	
	if Input.is_action_just_pressed("LOCK_MOUSE"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("PRIMARY"):
		primary.emit()
	
	if Input.is_action_just_pressed("BACK"):
		back.emit()
	
	if Input.is_action_pressed("SECONDARY"):
		fbrl = (get_tree().root.get_mouse_position() - get_tree().root.size * 0.5).normalized()
	else:
		fbrl = Vector2()
	fbrl += Input.get_vector("L","R","FW","BW",0.1)
	fbrl.limit_length()
	set_deferred("ml_udrl", Vector2())
