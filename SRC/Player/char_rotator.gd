extends Node3D

class_name CharRotator

@export var player : Player

var rotMomentum : float = 0.0
var baseSpRot : float = 0.0
func _physics_process(delta: float) -> void:
	match player.mode:
		Player.RUNNING:
			if rotMomentum > 0.01:
				rotMomentum = lerpf(rotMomentum, 0.0, 2.0 * delta)
				baseSpRot -= rotMomentum * delta
				var dir = Vector2(player.linear_velocity.z,player.linear_velocity.x).angle() + PI
				var aRt = lerp_angle(dir if player.hSpeed > 0.2 else baseSpRot, baseSpRot, clamp(abs(rotMomentum / 2.0),0,1))
				global_rotation.y = lerp_angle(global_rotation.y, aRt, delta * 6.0)
			elif player.hSpeed > 0.2:
				global_rotation.y = lerp_angle(global_rotation.y, Vector2(player.linear_velocity.z,player.linear_velocity.x).angle() + PI, 4.0 * delta)
		Player.SPEEN, Player.AIM:
			global_rotation.y -= player.speenPower * delta * 2.0
			rotMomentum = player.speenPower * 2.0
			baseSpRot = global_rotation.y
		Player.GRABBING:
			pass
