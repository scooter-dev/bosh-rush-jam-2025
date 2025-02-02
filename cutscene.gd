extends Area3D

class_name BossCutscene

@export_multiline var text : String
@export_category("Components")
@export var player : Player
@export var camera : Camera3D
@export var cameraDestination : Node3D
@export var name_label: Label
@export var boss : BossZombie
@export var lockDoor : Door

var done = false

func _ready() -> void:
	body_entered.connect(onBodyEntered)

func onBodyEntered(body : Node3D) -> void:
	start()

func start() -> void:
	if done:
		return
	done = true
	player.togglePlayer(false)
	player.cam.camera.current = false
	camera.current = true
	var tween : Tween = create_tween()
	tween.tween_property(camera, "global_position", cameraDestination.global_position, 2.0)
	create_tween().tween_property(camera, "global_rotation", cameraDestination.global_rotation, 2.0)
	tween.finished.connect(flyFinished)

func flyFinished() -> void:
	name_label.text = text
	name_label.visible = true
	await get_tree().create_timer(2.0).timeout
	name_label.visible = false
	player.togglePlayer(true)
	player.cam.camera.current = true
	camera.current = false
	if lockDoor:
		lockDoor.lock(true)
	await get_tree().create_timer(1.0).timeout
	boss.startFight()
