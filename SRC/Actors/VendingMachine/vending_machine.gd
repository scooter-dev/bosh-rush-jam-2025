extends Node3D

var shopping : bool = false

enum {LOOKING, KEYPAD, BUY}

var state : int = LOOKING

func _ready() -> void:
	for item : VMItem in itemsNode.get_children():
		items[item.code] = item
	set_physics_process(shopping)
	PlayerInput.primary.connect(onPrimaryPressed)

@export var camera : Camera3D
@export var l_browse_center : Node3D
@export var l_keypad : Node3D
@export var l_buy : Node3D
@export var button_1: VendingMachineButton
@export var num_panel: NumPanel
@export var itemsNode: Node3D
var items : Dictionary[int, Node3D]

var lookPos : float = 0.0
var pressLock : bool = true
var currentButton : VendingMachineButton

const btnThreshold : float = cos(deg_to_rad(45))

func startShopping() -> void:
	player.togglePlayer(false)
	player.cam.camera.current = false
	player.visible = false
	shopping = true
	camera.current = true
	set_physics_process(shopping)

signal stoppedShopping
func stopShopping() -> void:
	shopping = false
	camera.current = false
	stoppedShopping.emit()
	animation_player.play("RESET")
	player.togglePlayer(true)
	player.cam.camera.current = true
	player.visible = true
	set_physics_process(shopping)

func onPrimaryPressed() -> void:
	if shopping:
		if state == KEYPAD:
			match currentButton.number:
				VendingMachineButton.e_num.ACCEPT:
					buy()
				VendingMachineButton.e_num.CANCEL:
					if num_panel.cancelPressed():
						stopShopping()
				_:
					num_panel.addNum(currentButton.number)
		elif state == BUY:
			animation_player.play("RESET")
			state = KEYPAD
	

var buyItem : VMItem = null
func buy() -> void:
	var num : int = num_panel.getNumber()
	if num == -1:
		num_panel.acceptPressed(1)
		buyItem = null
	if items.has(num):
		buyItem = items[num]
		if PlayerManager.money >= buyItem.price:
			if buyItem.buy():
				num_panel.acceptPressed(0)
				PlayerManager.addItem(buyItem.item)
				PlayerManager.removeMoney(buyItem.price)
				state = BUY
				showMesh()
			else:
				num_panel.acceptPressed(1)
				buyItem = null
		else:
			num_panel.acceptPressed(2)
			buyItem = null
	else:
		num_panel.acceptPressed(1)
		buyItem = null

func _physics_process(delta: float) -> void:
	if !shopping:
		return
	match state:
		LOOKING:
			lookPos = clamp(lookPos - delta * PlayerInput.fbrl.y, -0.4,0.25)
			camera.global_position = lerp(camera.global_position, l_browse_center.global_position + Vector3(0,lookPos,0), delta * 4.0)
			camera.global_rotation.x = lerp_angle(camera.global_rotation.x, l_browse_center.global_rotation.x, delta * 3.0)
			if PlayerInput.fbrl.x > 0.5:
				currentButton = button_1
				button_1.highlight()
				state = KEYPAD
				pressLock = true
		KEYPAD:
			camera.global_position = lerp(camera.global_position, l_keypad.global_position, delta * 4.0)
			camera.global_rotation.x = lerp_angle(camera.global_rotation.x, l_keypad.global_rotation.x, delta * 3.0)
			if pressLock:
				pressLock = PlayerInput.fbrl.length_squared() > 0.04
				return
			
			
			if PlayerInput.fbrl.dot(Vector2(-1,0)) > btnThreshold:
				currentButton.unhighlight()
				pressLock = true
				if currentButton.left:
					currentButton = currentButton.left
					currentButton.highlight()
				else:
					currentButton.unhighlight()
					state = LOOKING
			elif PlayerInput.fbrl.dot(Vector2(1,0)) > btnThreshold:
				pressLock = true
				if currentButton.right:
					currentButton.unhighlight()
					currentButton = currentButton.right
					currentButton.highlight()
			elif PlayerInput.fbrl.dot(Vector2(0,-1)) > btnThreshold:
				pressLock = true
				if currentButton.up:
					currentButton.unhighlight()
					currentButton = currentButton.up
					currentButton.highlight()
			elif PlayerInput.fbrl.dot(Vector2(0,1)) > btnThreshold:
				pressLock = true
				if currentButton.down:
					currentButton.unhighlight()
					currentButton = currentButton.down
					currentButton.highlight()
			
		BUY:
			camera.global_position = lerp(camera.global_position, l_buy.global_position, delta * 4.0)
			camera.global_rotation.x = lerp_angle(camera.global_rotation.x, l_buy.global_rotation.x, delta * 3.0)
			

@export var animation_player: AnimationPlayer
@export var item_show: MeshInstance3D
func showMesh() -> void:
	item_show.mesh = buyItem.mesh
	item_show.rotation_degrees = buyItem.showRotation
	item_show.position = buyItem.offset
	animation_player.play("ShowItem")
	buyItem = null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass

var player : Player
func _on_interaction_area_interacted(instigator: Node3D) -> void:
	if instigator is Player:
		player = instigator
		startShopping()
