extends Node3D

@export var currentFloor : int = -1
@export var camera: Camera3D
@export var door_big: CharacterBody3D
@export var door_small: CharacterBody3D
@export var button_1: VendingMachineButton
@export var num_panel: NumPanel

var active : bool = false

func close() -> void:
	create_tween().tween_property(door_big, "position:x", 1.0, 2.0)
	create_tween().tween_property(door_small, "position:x", -1.05, 2.0)

func open() -> void:
	create_tween().tween_property(door_big, "position:x", 2.05, 2.0)
	create_tween().tween_property(door_small, "position:x", -0.1, 2.0)

func _ready() -> void:
	PlayerInput.primary.connect(onPrimary)
	PlayerInput.back.connect(onBack)
	open()
	set_physics_process(false)

func activate() -> void:
	if playerInElevator and !noAc:
		player.died.connect(deactivate)
		player.damaged.connect(deactivate)
		player.togglePlayer(false)
		player.cam.camera.current = false
		camera.current = true
		player.visible = false
		selectButton(button_1)
		set_physics_process(true)
		active = true

var noAc : bool = false
func deactivate() -> void:
	if active:
		player.togglePlayer(true)
		player.cam.camera.current = true
		camera.current = false
		player.visible = true
		selectButton(null)
		set_physics_process(false)
		active = false
		noAc = true
		await get_tree().create_timer(0.5).timeout
		noAc = false

var selectedButton : VendingMachineButton = null

func selectButton(btn : VendingMachineButton) -> void:
	if selectedButton:
		selectedButton.unhighlight()
	selectedButton = btn
	if selectedButton:
		selectedButton.highlight()

const btnThreshold : float = cos(deg_to_rad(45))

var pressLock : bool = false



func onPrimary() -> void:
	if active:
		if selectedButton:
			match selectedButton.number:
				VendingMachineButton.e_num.CANCEL:
					if num_panel.getNumber() == -1:
						deactivate()
					else:
						num_panel.cancelPressed()
				VendingMachineButton.e_num.ACCEPT:
					var num : int = num_panel.getNumber()
					if num == currentFloor:
						deactivate()
					match num:
						101:
							close()
							await get_tree().create_timer(2.0).timeout
							PlayerManager.player.levelTransition("res://Scenes/Maps/Rooftop/rooftop.tscn")
						100:
							deactivate()
							close()
							await get_tree().create_timer(2.0).timeout
							PlayerManager.player.levelTransition("res://Scenes/Maps/CEOArena/CEOArena.tscn")
						80:
							close()
							await get_tree().create_timer(2.0).timeout
							PlayerManager.player.levelTransition("res://Scenes/Maps/DirectorArena/director_arena.tscn")
						40:
							close()
							await get_tree().create_timer(2.0).timeout
							PlayerManager.player.levelTransition("res://Scenes/Maps/ManagerArena/manager_arena.tscn")
						12:
							close()
							await get_tree().create_timer(2.0).timeout
							PlayerManager.player.levelTransition("res://Scenes/Maps/SafeRoom/SafeRoom.tscn")
						_:
							close()
							await get_tree().create_timer(2.0).timeout
							PlayerManager.player.levelTransition("res://SRC/Actors/ProcGen/level_gen.tscn")
				_:
					num_panel.addNum(selectedButton.number)

func onBack() -> void:
	if active:
		deactivate()

func _physics_process(delta: float) -> void:
	if selectedButton == null:
		selectButton(button_1)
	
	if pressLock:
		pressLock = PlayerInput.fbrl.length_squared() > 0.04
		return
	
	if PlayerInput.fbrl.dot(Vector2(-1,0)) > btnThreshold:
			pressLock = true
			if selectedButton.left:
				selectButton(selectedButton.left)
	elif PlayerInput.fbrl.dot(Vector2(1,0)) > btnThreshold:
		pressLock = true
		if selectedButton.right:
			selectButton(selectedButton.right)
	elif PlayerInput.fbrl.dot(Vector2(0,-1)) > btnThreshold:
		pressLock = true
		if selectedButton.up:
			selectButton(selectedButton.up)
	elif PlayerInput.fbrl.dot(Vector2(0,1)) > btnThreshold:
		pressLock = true
		if selectedButton.down:
			selectButton(selectedButton.down)

var playerInElevator : bool = false
func _on_player_in_elevator_body_entered(body: Node3D) -> void:
	playerInElevator = true

func _on_player_in_elevator_body_exited(body: Node3D) -> void:
	playerInElevator = false

var player : Player
func _on_interaction_area_interacted(instigator: Node3D) -> void:
	if instigator is Player:
		player = instigator
		activate()
