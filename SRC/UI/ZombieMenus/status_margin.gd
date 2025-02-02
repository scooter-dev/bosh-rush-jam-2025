extends MarginContainer


@export var boostIcon: TextureProgressBar
@export var shieldIcon: Label
@export var healthBar: TextureProgressBar

var health: int
var boostCooldown: float
var boostDelay: float


func _process(delta):
	health = PlayerManager.health
	healthBar.set_value_no_signal(health)
	checkCooldown()
	boostIcon.set_value_no_signal(boostCooldown-boostDelay)
	updateArmorCounter(PlayerManager.armor)


func checkCooldown():
	boostCooldown = PlayerManager.boostCooldown
	boostDelay = PlayerManager.boostDelay

#shows shield status
func displayShield():
	shieldIcon.show()

func updateArmorCounter(armorCount: int):
	shieldIcon.set_text("Armor: "+String.num(armorCount))
