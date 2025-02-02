extends Control

@export var isPauseMenu : bool = false
@export var resume_button: Button
# @export var options_button: OptionsMenu
@export var margin_container: MarginContainer

func _ready() -> void:
	PlayerInput.pause.connect(pausePressed)
	if isPauseMenu:
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
		get_tree().change_scene_to_file()

func unpause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
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
