extends Control

@export var isPauseMenu : bool = false
@export var resume_button: Button
# @export var options_button: OptionsMenu
@export var margin_container: MarginContainer
@export var self_destruct: Button
@export var selfDestructBlock : bool

func _ready() -> void:
	PlayerInput.pause.connect(pausePressed)
	resume_button.grab_focus()
	if isPauseMenu:
		self_destruct.visible = true
		resume_button.text = "Resume"

var lastTimeScale : float = 1.0
func pausePressed() -> void:
	if get_tree().paused:
		# if !margin_container.visible:
		#     options.close()
		unpause()
		Engine.time_scale = lastTimeScale
	else:
		lastTimeScale = Engine.time_scale
		Engine.time_scale = 1.0
		pause()

func pause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	show()
	resume_button.grab_focus()

func _on_resume_pressed() -> void:
	if isPauseMenu:
		unpause()
	else:
		print("load")
		WorldManager.toLoad = "res://Scenes/Maps/Tutorial/tutorial.tscn"
		get_tree().change_scene_to_file("res://SRC/UI/loading.tscn")

func unpause() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	hide()


# func _on_return_pressed() -> void:
#   unpause()


func _on_options_pressed() -> void:
	pass
	# if !options.visible:
	#    options.open()
	#    margin_container.visible = false

func _on_options_closed() -> void:
	# margin_container.visible = true
	resume_button.grab_focus()

@onready var help: Panel = $Help
@onready var close_help: Button = $Help/CloseHelp

func _on_help_menu_button_pressed() -> void:
	help.visible = true
	close_help.grab_focus()

func _on_close_help_pressed() -> void:
	help.visible = false
	resume_button.grab_focus()

@onready var options_menu: Control = $OptionsMenu
@onready var main_menu_container: MarginContainer = $MainMenuContainer

func _on_settings_menu_button_pressed() -> void:
	main_menu_container.hide()
	options_menu.open()


func _on_options_menu_closed() -> void:
	main_menu_container.show()
	resume_button.grab_focus()


func _on_self_destruct_pressed() -> void:
	if PlayerManager.player:
		Dialogic.end_timeline()
		if selfDestructBlock:
			PlayerManager.resetInventory()
			WorldManager.toLoad = "res://Scenes/Maps/Tutorial/tutorial.tscn"
			PlayerManager.player.levelTransition("res://SRC/UI/loading.tscn")
		else:
			PlayerManager.player.die()
		unpause()
