extends Control

@onready var mouse_sens: HSlider = $Panel/VBoxContainer/MouseSens
@onready var controller_sens: HSlider = $Panel/VBoxContainer/ControllerSens
@onready var master_audio: HSlider = $Panel/VBoxContainer/MasterAudio
@onready var music_volume: HSlider = $Panel/VBoxContainer/MusicVolume
@onready var sfx_volume: HSlider = $Panel/VBoxContainer/SFXVolume

func _ready() -> void:
	update()

func update() -> void:
	mouse_sens.value = OptionsManager.mouseSensitivity
	controller_sens.value = OptionsManager.controllerSensitivity
	master_audio.value = AudioServer.get_bus_volume_linear(0)
	music_volume.value = AudioServer.get_bus_volume_linear(1)
	sfx_volume.value = AudioServer.get_bus_volume_linear(2)

func open() -> void:
	mouse_sens.grab_focus()
	update()
	show()

func _on_mouse_sens_value_changed(value: float) -> void:
	OptionsManager.mouseSensitivity = value


func _on_controller_sens_value_changed(value: float) -> void:
	OptionsManager.controllerSensitivity = value


func _on_close_pressed() -> void:
	close()

signal closed
func close() -> void:
	hide()
	closed.emit()


func _on_master_audio_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)

func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, value)

func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, value)


func _on_line_edit_text_submitted(new_text: String) -> void:
	match new_text:
		"frog":
			PlayerManager.invulnerable != PlayerManager.invulnerable
		"idkfa":
			PlayerManager.addItem(PlayerManager.e_items.GLUE, 999)
			PlayerManager.addItem(PlayerManager.e_items.STAPLES, 999)
			PlayerManager.addItem(PlayerManager.e_items.TAPE, 999)
			PlayerManager.addItem(PlayerManager.e_items.PHONE_BOOK, 999)
			PlayerManager.addItem(PlayerManager.e_items.SODA, 999)
			PlayerManager.addItem(PlayerManager.e_items.CANDY, 999)
			PlayerManager.addItem(PlayerManager.e_items.TUBING, 999)
			PlayerManager.addItem(PlayerManager.e_items.WIRES, 999)
			PlayerManager.addItem(PlayerManager.e_items.CHIP, 999)
			PlayerManager.addItem(PlayerManager.e_items.CIRCUIT_BOARD, 999)
			PlayerManager.addItem(PlayerManager.e_items.PEN, 999)
			PlayerManager.addItem(PlayerManager.e_items.OIL, 999)
			
