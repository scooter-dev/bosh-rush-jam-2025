extends MeshInstance3D

@onready var heli_001: MeshInstance3D = $Heli_001
@onready var heli_002: MeshInstance3D = $Heli_002
@onready var heli_003: MeshInstance3D = $Heli_003
@onready var heli_004: MeshInstance3D = $Heli_004

@export var animPlayer : AnimationPlayer

func _process(delta: float) -> void:
	heli_001.rotate_y(delta * 80.0)
	heli_002.rotate_y(-delta * 80.0)
	heli_003.rotate_x(delta * 80.0)
	heli_004.rotate_x(-delta * 80.0)

@export var charPosition : Node3D
@export var camera : Camera3D
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.togglePlayer(false)
		body.freeze = true
		body.reparent(self)
		body.cam.camera.current = false
		camera.current = true
		body.global_position = charPosition.global_position
		body.global_rotation = Vector3()
		animPlayer.play("Bye")

func loadCredits() -> void:
	pass
