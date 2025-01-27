extends Area3D

class_name GrabArea

@export var player : Player

var grabbed : GrabbableProp = null

func interact() ->void:
	match player.mode:
		Player.RUNNING:
			if !grabbed:
				for body : PhysicsBody3D in get_overlapping_bodies():
					if body is GrabbableProp:
						body.freeze = true
						body.setNoCol()
						body.reparent(self)
						body.position = Vector3()
						body.rotation = Vector3()
						if body.grabPoint:
							body.rotation = body.grabPoint.rotation
							body.position = body.grabPoint.position
						grabbed = body
						return
				for area : InteractionArea in get_overlapping_areas():
					area.onInteracted(player)
					return
			else:
				grabbed.reparent(WorldManager.currentLevel)
				grabbed.setCol()
				grabbed.freeze = false
				grabbed = null
				print("Drop")

func throw(dir : Vector3, str : float) -> void:
	if grabbed:
		grabbed.reparent(WorldManager.currentLevel)
		grabbed.freeze = false
		grabbed.apply_central_impulse(dir * str)
		grabbed.thrown(player)
		grabbed = null
