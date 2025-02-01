extends AnimationTree

@export var zombie : Zombie
@export var zombieAttackArea : ZombieAttackArea

func _ready() -> void:
	zombieAttackArea.playerInArea.connect(onAttackPlayer)

func onAttackPlayer() -> void:
	if self["parameters/B2_AtkLR/blend_amount"] > 0.5:
		self["parameters/B2_AtkLR/blend_amount"] = 0
	else:
		self["parameters/B2_AtkLR/blend_amount"] = 1
	self["parameters/OST_Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	self["parameters/OST_Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _process(delta: float) -> void:
	var zSpeed : float = zombie.linear_velocity.length()
	self["parameters/B2_IdleWalk/blend_amount"] = clamp(zSpeed * 3.0, 0.0, 1.0)
	self["parameters/TS_IR/scale"] = clamp(zSpeed * 0.125, 1.0, 3.0)
	match zombie.mode:
		Zombie.WANDERING,Zombie.RETURNING:
			self["parameters/B2_Chase/blend_amount"] = lerp(self["parameters/B2_Chase/blend_amount"], 0.0, delta * 6.0)
		Zombie.LOSING, Zombie.CHASING:
			self["parameters/B2_Chase/blend_amount"] = lerp(self["parameters/B2_Chase/blend_amount"], 1.0, delta * 6.0)
	pass
