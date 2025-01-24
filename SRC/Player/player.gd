extends RigidBody3D

class_name Player

@export var cam : PlayerCamera
@export var charRotator : CharRotator
@export var grabArea : GrabArea
var acceleration : float = 12.0
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
var boostStrength : float = 0.3
var launchPower : float = 0.25
var grabStrength : float = 0.3
var rotSpeedLimit : float = 6.0
var turnSpeed : float = 0.25

#var groundVelocity : Vector3 = Vector3()
var slideVelocity : Vector3 = Vector3()

func _ready() -> void:
	PlayerInput.primary.connect(onPrimary)

func onPrimary() -> void:
	primaryPressed = true

var primaryPressed : bool = false

func _physics_process(delta: float) -> void:
	#groundVelocity = Vector3()
	hSpeed = linear_velocity.length()
	var dir : Vector3 = cam.global_basis.x * PlayerInput.fbrl.x + cam.global_basis.z * PlayerInput.fbrl.y
	dir = dir.limit_length()
	
	label.text = "RDS: %0.2f" % rotDeltaSum
	
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
				grabArea.grabLetGo()
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
				
				rotDeltaSum += angleDifference * turnSpeed
				prevRotation = currentRotation
			
			rotDeltaSum = lerpf(rotDeltaSum, 0.0, delta * 0.5)
			speenPower = lerp(speenPower, clamp(rotDeltaSum, -rotSpeedLimit, rotSpeedLimit), delta * 8.0)
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
			speenPower = lerp(speenPower, clamp(rotDeltaSum, -rotSpeedLimit, rotSpeedLimit), delta * 6.0)
			if abs(speenPower) < 1.0:
				mode = RUNNING
				speenPower = 0.0
				rotDeltaSum = 0.0
			elif primaryPressed:
				rotDeltaSum = 0.0
				Engine.time_scale = 1.0
				if grabArea.grabbed:
					grabArea.throw(-charRotator.global_basis.z, abs(speenPower) * 5 * launchPower)
				else:
					slideVelocity -= charRotator.global_basis.z * abs(speenPower) * 20000.0 * boostStrength
				mode = RUNNING
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
