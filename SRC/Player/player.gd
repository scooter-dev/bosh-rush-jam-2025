extends RigidBody3D

class_name Player

var playerEnabled : bool = true

@export var cam : PlayerCamera
@export var charRotator : CharRotator
@export var grabArea : GrabArea
@export var damageNumberSpawner : DamageNSpawner
var acceleration : float = 18.0
var damping : float = 30.0

enum {RUNNING, GRABBING, SPEEN, AIM}

var mode : int = RUNNING
var hSpeed : float = 0.0


@onready var prevRotation : float = charRotator.global_rotation.y

var rotDeltaSum : float = 0.0
var rotResetTimer : float = 0.0
@onready var label: Label = $Label
var speenPower : float = 0.0

#Stats

#var groundVelocity : Vector3 = Vector3()
var slideVelocity : Vector3 = Vector3()

func _enter_tree() -> void:
	PlayerManager.player = self

func _ready() -> void:
	PlayerInput.primary.connect(onPrimary)
	PlayerInput.boost.connect(onBoost)

func onPrimary() -> void:
	if !playerEnabled:
		return
	primaryPressed = true

var shouldBoost : bool
func onBoost() -> void:
	shouldBoost = true

var primaryPressed : bool = false

var boostDelay : float = 0.0

func _physics_process(delta: float) -> void:
	if !playerEnabled:
		return
	#groundVelocity = Vector3()
	iTime = max(0.0, iTime - delta)
	hSpeed = linear_velocity.length()
	var dir : Vector3 = cam.global_basis.x * PlayerInput.fbrl.x + cam.global_basis.z * PlayerInput.fbrl.y
	dir = dir.limit_length()
	
	label.text = "RDS: %0.2f" % rotDeltaSum
	boostDelay -= delta
	match mode:
		RUNNING:
			#groundVelocity.x -= groundVelocity.x * delta * damping
			#groundVelocity.z -= groundVelocity.z * delta * damping
			apply_central_force(dir * acceleration)
			
			if dir.length_squared() > 0.01:
				var currentRotation = Vector2(dir.x,dir.z).angle()
				var angleDifference : float = wrap_angle(currentRotation - prevRotation)
				if sign(rotDeltaSum) != 0 and abs(angleDifference) > 0.1:
					if sign(rotDeltaSum) != sign(angleDifference):
						rotDeltaSum = 0
				
				rotDeltaSum += angleDifference
				prevRotation = currentRotation
			if primaryPressed:
				grabArea.interact()
			if shouldBoost and boostDelay < 0.001:
				slideVelocity -= charRotator.global_basis.z * 8000.0 * PlayerManager.boostStrength * PlayerManager.boostStrength
				print("boosted")
				shouldBoost = false
				boostDelay = PlayerManager.boostCooldown
			if rotDeltaSum > 0.0:
				rotDeltaSum = max(0.0, rotDeltaSum - 7.0 * delta)
			else:
				rotDeltaSum = min(0.0, rotDeltaSum + 7.0 * delta)
			if abs(rotDeltaSum) > 2 * PI:
				mode = SPEEN
				rotDeltaSum = sign(rotDeltaSum) * 4.0
				speenPower = rotDeltaSum
		GRABBING:
			#groundVelocity.x -= groundVelocity.x * delta * damping
			#groundVelocity.z -= groundVelocity.z * delta * damping
			apply_central_force(dir * acceleration * 0.3)
			
			#else:
			#	groundVelocity.y = clamp(groundVelocity.y - 9.8 * delta, -60,60)
		SPEEN:
			label.text += "\nSPEEN: %0.2f" % speenPower
			#groundVelocity.x -= groundVelocity.x * delta * damping * 3.0
			#groundVelocity.z -= groundVelocity.z * delta * damping * 3.0
			
			if dir.length_squared() > 0.01:
				var currentRotation = Vector2(dir.x,dir.z).angle()
				var angleDifference : float = wrap_angle(currentRotation - prevRotation)
				#if sign(rotDeltaSum) != 0 and abs(angleDifference) > 0.1:
				#	if sign(rotDeltaSum) != sign(angleDifference):
				#		rotDeltaSum = 0
				
				rotDeltaSum += angleDifference * PlayerManager.turnSpeed
				prevRotation = currentRotation
			
			rotDeltaSum = lerpf(rotDeltaSum, 0.0, delta * 0.5)
			speenPower = lerp(speenPower, clamp(rotDeltaSum, -PlayerManager.rotSpeedLimit, PlayerManager.rotSpeedLimit), delta * 8.0)
			if primaryPressed:
				Engine.time_scale = 0.12 / max(abs(speenPower) / 6.0,0.25)
				mode = AIM
				#print("AIM")
			if abs(speenPower) < 1:
				mode = RUNNING
				speenPower = 0.0
				rotDeltaSum = 0.0
		AIM:
			rotDeltaSum = lerpf(rotDeltaSum, 0.0, delta * 0.125)
			speenPower = lerp(speenPower, clamp(rotDeltaSum, -PlayerManager.rotSpeedLimit, PlayerManager.rotSpeedLimit), delta * 6.0)
			if abs(speenPower) < 1.0:
				mode = RUNNING
				speenPower = 0.0
				rotDeltaSum = 0.0
			elif primaryPressed:
				rotDeltaSum = 0.0
				Engine.time_scale = 1.0
				if grabArea.grabbed:
					grabArea.throw(-charRotator.global_basis.z, abs(speenPower) * 5 * PlayerManager.launchPower)
				else:
					slideVelocity -= charRotator.global_basis.z * abs(speenPower) * 10000.0 * max(0.25,PlayerManager.boostStrength)
				mode = RUNNING
	
	if mode != RUNNING:
		shouldBoost = false
	primaryPressed = false
	slideVelocity -= slideVelocity * delta * 6.0
	#groundVelocity.y = 0.0
	slideVelocity.y = 0.0
	label.text += "\nSLD: " + str(slideVelocity)
	apply_central_force(slideVelocity)
	slideVelocity = Vector3()

func setMode(nMode : int) -> void:
	match mode:
		RUNNING:
			pass
		SPEEN:
			pass
		AIM:
			pass

func wrap_angle(angle: float) -> float:
	while angle > PI:
		angle -= TAU
	while angle < -PI:
		angle += TAU
	return angle

func togglePlayer(state : bool) -> void:
	playerEnabled = state

var iTime : float = 0.0
signal damaged
func onDamaged(damage : int, instigator : Node3D) -> void:
	if iTime < 0.001:
		iTime = 0.2
		damaged.emit()
		PlayerManager.health -= damage
		damageNumberSpawner.spawnDNumber(damage)
		print("player damage")
		if PlayerManager.health <= 0:
			die()


signal died
var dead : bool = false
func die() -> void:
	mode = RUNNING
	Engine.time_scale = 1.0
	$CharRotator/PlayerCharacter/Character/Armature/Skeleton3D/PhysicalBoneSimulator3D.physical_bones_start_simulation()
	died.emit()
	dead = true
	togglePlayer(false)
