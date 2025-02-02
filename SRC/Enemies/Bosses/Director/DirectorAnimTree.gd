extends AnimationTree

@export var boss : BossZombie
@export var bossAI : DirectorAI

func onPlayerInRange() -> void:
	if self["parameters/B2_AtkLR/blend_amount"] > 0.5:
		self["parameters/B2_AtkLR/blend_amount"] = 0.0
	else:
		self["parameters/B2_AtkLR/blend_amount"] = 1.0
	#self["parameters/OST_Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	self["parameters/OST_Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _process(delta: float) -> void:
	self["parameters/B2_IdleWalk/blend_amount"] = clamp(boss.linear_velocity.length_squared() / 26.0,0,1)
	self["parameters/B2_Hit/blend_amount"] = lerpf(self["parameters/B2_Hit/blend_amount"],float(bossAI.state == ManagerAI.PREPARE_SPECIAL), delta * 4.0)
