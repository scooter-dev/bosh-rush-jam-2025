extends Node3D

class_name CharRotator

@export var player : Player
@export var arrow : MeshInstance3D

var rotMomentum : float = 0.0
var baseSpRot : float = 0.0
var lastRot : float = 0.0
const hPI : float = PI/2
func _physics_process(delta: float) -> void:
	if !player.playerEnabled:
		return
	match player.mode:
		Player.RUNNING:
			arrow.visible = false
			if abs(rotMomentum) > 0.01:
				var dir : Vector3 = player.cam.global_basis.x * PlayerInput.fbrl.x + player.cam.global_basis.z * PlayerInput.fbrl.y
				lastRot = Vector2(-dir.x,dir.z).angle() + hPI if PlayerInput.fbrl.length_squared() > 0.01 else lastRot
				rotMomentum = lerpf(rotMomentum, 0.0, 2.0 * delta)
				baseSpRot -= rotMomentum * delta
				
				var aRt = lerp_angle(lastRot, baseSpRot, clamp(abs(rotMomentum * 0.5),0,1))
				global_rotation.y = lerp_angle(global_rotation.y, aRt, delta * 6.0)
				#print(rotMomentum)
			elif PlayerInput.fbrl.length_squared() > 0.01:
				var dir : Vector3 = player.cam.global_basis.x * PlayerInput.fbrl.x + player.cam.global_basis.z * PlayerInput.fbrl.y
				lastRot = Vector2(-dir.x,dir.z).angle() + hPI if PlayerInput.fbrl.length_squared() > 0.01 else lastRot
				global_rotation.y = lerp_angle(global_rotation.y, lastRot, 4.0 * delta)
		Player.SPEEN, Player.AIM:
			arrow.visible = true
			global_rotation.y -= player.speenPower * delta * 2.0
			rotMomentum = player.speenPower * 2.0
			baseSpRot = global_rotation.y
			lastRot = global_rotation.y
