extends MarginContainer


@export var boostIcon: TextureProgressBar
@export var shieldIcon: Label
@export var healthBar: TextureProgressBar
@export var healthCount: Label
@export var moneyCount: Label

var health: int
var boostCooldown: float
var boostDelay: float


func _process(delta):
	updateHealthbar()
	checkCooldown()
	updateArmorCounter(PlayerManager.armor)
	updateBalance()

func checkCooldown():
	boostCooldown = PlayerManager.boostCooldown
	boostDelay = PlayerManager.boostDelay
	boostIcon.set_value_no_signal(boostCooldown-boostDelay)

#shows shield status
func displayShield():
	shieldIcon.show()

func updateArmorCounter(armorCount: int):
	shieldIcon.set_text("Armor: "+String.num(armorCount))

func updateHealthbar():
	health = PlayerManager.health
	healthBar.set_value_no_signal(health)
	healthCount.set_text("Health: "+String.num(health)+"/"+String.num(PlayerManager.maxHealth))

func updateBalance():
	moneyCount.set_text("Money: "+String.num(PlayerManager.money))
