extends Node

class_name PlayerMovement

enum {M_FALLING, M_GROUNDED, M_RAGDOLL, M_CROUCHED}

@export var player : Player
@export var camera : PlayerCamera
@export var groundRays : GroundRays

var movementMode : int = M_FALLING
var velocity : Vector3 = Vector3()
var acceleration : float = 72.0
var damping : float = 16.0
var jumpImpulse : float = 4.0

##Proceses the movement mode for the current frame
func mMode() -> void:
	match movementMode:
		M_GROUNDED:
			if groundRays.groundDistance > 0.325:
				setMMode(M_FALLING)
		M_FALLING:
			if groundRays.groundDistance < 0.0 and velocity.y < 3.0:
				setMMode(M_GROUNDED)
		M_RAGDOLL:
			pass
		M_CROUCHED:
			pass

##Sets the movement mode do newMMode, doing any necessary tasks for the switch. Always use this to change movement mode.
func setMMode(newMMode : int) -> void:
	
	match movementMode:
		M_GROUNDED:
			match newMMode:
				M_FALLING:
					pass #TODO reparent player to world, don't forget multiplayer
		M_FALLING:
			match newMMode:
				M_GROUNDED:
					pass #TODO reparent player to ground, don't forget multiplayer
	
	movementMode = newMMode

##Starts the player reparenting operations
func reparentPlayer(reparentTo : Node3D) -> void:
	reparentPlayerRPC.rpc(reparentTo)

##Reparents the player character to a new node on all clients, making sure everything is synced up. Needs to be called from reparentPlayer or with RPC. 
@rpc("authority", "call_local", "reliable")
func reparentPlayerRPC(reparentTo : Node3D) -> void:
	player.reparent(reparentTo)

func _physics_process(delta: float) -> void:
	if player.isLocal:
		velocity = player.get_real_velocity()
		mMode()
		
		var dir : Vector3 = PlayerInput.fbrl.x * camera.global_basis.x + PlayerInput.fbrl.y * camera.global_basis.z
		dir = dir.limit_length()
		
		match movementMode:
			M_GROUNDED:
				velocity.x -= velocity.x * delta * damping
				velocity.z -= velocity.z * delta * damping
				
				velocity += dir * delta * acceleration
				
				velocity.y = clamp(-groundRays.groundDistance * 1200.0 * delta, -6, 6)
			M_FALLING:
				velocity.y = clamp(velocity.y - ProjectSettings.get_setting("physics/3d/default_gravity") * delta, -30, 30)
			M_RAGDOLL:
				pass
			M_CROUCHED:
				pass
		
		player.velocity = velocity
		player.move_and_slide()
	else:
		pass
