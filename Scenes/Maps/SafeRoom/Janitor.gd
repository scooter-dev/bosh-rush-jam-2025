extends StaticBody3D

var player : Player
var running : bool = false

@onready var character_mesh: MeshInstance3D = $"../Character/Armature/Skeleton3D/CharacterMesh"


func _ready() -> void:
	Dialogic.timeline_ended.connect(onTimelineEnded)

func onTimelineEnded() -> void:
	closeDialog()

func openDialog() -> void:
	player.togglePlayer(false)
	if Dialogic.current_timeline != null:
		return
	Dialogic.start('JanitorTalk')
	running = true

func closeDialog() -> void:
	if running:
		player.togglePlayer(true)
		running = false


func _on_interaction_area_interacted(instigator: Node3D) -> void:
	if instigator is Player:
		player = instigator
		openDialog()


func _on_interaction_area_sel(col: Color) -> void:
	character_mesh.material_overlay.albedo_color = col


func _on_interaction_area_unsel() -> void:
	character_mesh.material_overlay.albedo_color = Color(1,1,1,0)
