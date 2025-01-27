extends Node

class_name BossAi

@export var boss : BossZombie

func _ready() -> void:
    boss.damaged.connect(aiReaction)
    boss.dead.connect(aiDefeat)

    GrabbableProp.DamageType.CAT
    pass

func _physics_process(_delta):
    aiTick()

func aiTick() -> void:
    pass

func aiReaction(amount : int, instigator : Node3D, grabbable: GrabbableProp) -> void:
    pass

func aiDefeat() -> void:
    pass