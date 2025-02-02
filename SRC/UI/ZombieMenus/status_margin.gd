extends MarginContainer


@export var boostIcon: TextureProgressBar
@export var shieldIcon: Label
@export var healthBar: TextureProgressBar
@export var moneyCount: Label

var health: int
var boostCooldown: float
var boostDelay: float


func _process(delta):
	health = PlayerManager.health
	healthBar.set_value_no_signal(health)
	checkCooldown()
	boostIcon.set_value_no_signal(boostCooldown-boostDelay)
	updateArmorCounter(PlayerManager.armor)
	moneyCount.set_text("Money: "+String.num(PlayerManager.money))


func checkCooldown():
	boostCooldown = PlayerManager.boostCooldown
	boostDelay = PlayerManager.boostDelay

#shows shield status
func displayShield():
	shieldIcon.show()

func updateArmorCounter(armorCount: int):
	shieldIcon.set_text("Armor: "+String.num(armorCount))
