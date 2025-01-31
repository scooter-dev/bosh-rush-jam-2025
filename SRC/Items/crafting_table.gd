extends Node3D

class_name CraftingTable

var player : Player = null

@export_category("Components")
@export var cam : Camera3D
@export var camLooker : Node3D

@export var armorButton : CraftingButton
@export var armBrace : CraftingButton
@export var upgradeChairButton : CraftingButton
@export var upgradeBoosterButton : CraftingButton

@export var camPosCrafting : Node3D
@export var camPosLooking : Node3D
@export var lampHead : Node3D
@export var lampHeadCraft : Node3D
@export var lampHeadLook : Node3D

var highlightedButton : CraftingButton = null

func _ready() -> void:
	PlayerInput.primary.connect(onPrimary)
	PlayerInput.back.connect(onBack)
	set_physics_process(false)
	#start()

signal started
signal stopped

var enabled : bool = false

func start() -> void:
	if player:
		player.togglePlayer(false)
		player.cam.camera.current = false
	cam.current = true
	set_physics_process(true)
	enabled = true
	started.emit()

func stop() -> void:
	if enabled:
		cam.current = false
		highlightButton(null)
		if player:
			player.cam.camera.current = true
			player.togglePlayer(true)
		set_physics_process(false)
		enabled = false
		stopped.emit()

func onBack() -> void:
	stop()

func onPrimary() -> void:
	if enabled and state == CRAFTING:
		if highlightedButton:
			if PlayerManager.hasUpgradeRequirements(highlightedButton.upgrade):
				var req : Dictionary = PlayerManager.getUpgradeRequirements(highlightedButton.upgrade)
				for item : int in req.keys():
					PlayerManager.removeItem(item, req[item])
				PlayerManager.upgradePlayer(highlightedButton.upgrade)

func _on_interaction_area_interacted(instigator: Node3D) -> void:
	if instigator is Player:
		player = instigator
		start()

enum {CRAFTING, VIEWING}

var state : int

func highlightButton(button : CraftingButton) -> void:
	if highlightedButton:
		highlightedButton.unhighlight()
	highlightedButton = button
	if highlightedButton:
		highlightedButton.highlight()

const btnThreshold : float = cos(deg_to_rad(45))
var pressLock : bool = false
var viewPos : float = 0.0
func _physics_process(delta: float) -> void:
	match state:
		CRAFTING:
			lampHead.rotation = lerp(lampHead.rotation, lampHeadCraft.rotation, delta * 4.0)
			if highlightedButton == null:
				highlightButton(armBrace)
			camLooker.look_at(highlightedButton.lookAt.global_position)
			cam.global_transform = cam.global_transform.interpolate_with(camLooker.global_transform, delta * 4.0)
			cam.global_position = lerp(cam.global_position, camPosCrafting.global_position, delta * 8.0)
			if pressLock:
				pressLock = PlayerInput.fbrl.length_squared() > 0.04
				return
			
			if PlayerInput.fbrl.dot(Vector2(-1,0)) > btnThreshold:
				if highlightedButton.left:
					highlightButton(highlightedButton.left)
				pressLock = true
			elif PlayerInput.fbrl.dot(Vector2(1,0)) > btnThreshold:
				if highlightedButton.right:
					highlightButton(highlightedButton.right)
				else:
					state = VIEWING
					highlightButton(null)
				pressLock = true
			elif PlayerInput.fbrl.dot(Vector2(0,-1)) > btnThreshold:
				if highlightedButton.up:
					highlightButton(highlightedButton.up)
				pressLock = true
			elif PlayerInput.fbrl.dot(Vector2(0,1)) > btnThreshold:
				if highlightedButton.down:
					highlightButton(highlightedButton.down)
				pressLock = true
		VIEWING:
			lampHead.rotation = lerp(lampHead.rotation, lampHeadLook.rotation, delta * 4.0)
			cam.global_position = lerp(cam.global_position, camPosLooking.global_position - Vector3(0,0,viewPos), delta * 8.0)
			#viewPos = clamp(viewPos + PlayerInput.fbrl.y * delta * 0.5, 0.0, 0.5)
			cam.rotation.x = lerp_angle(cam.rotation.x, camPosLooking.rotation.x, delta * 8.0)
			cam.rotation.y = lerp_angle(cam.rotation.y, camPosLooking.rotation.y, delta * 8.0)
			cam.rotation.z = lerp_angle(cam.rotation.z, camPosLooking.rotation.z, delta * 8.0)
			if PlayerInput.fbrl.dot(Vector2(-1,0)) > btnThreshold:
				state = CRAFTING
				highlightButton(upgradeBoosterButton)
