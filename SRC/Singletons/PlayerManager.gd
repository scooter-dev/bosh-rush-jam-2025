extends Node

var player : Player
var otherPlayers : Array[Player]

enum e_items {GLUE, STAPLES, TAPE, PHONE_BOOK, SODA, CANDY, TUBING, WIRES, CHIP, CIRCUIT_BOARD, PEN, LASER_POINTER, OIL}

var keys : Array[String] = []

func getKey(key : String) -> bool:
	if keys.has(key):
		return true
	return false

var money : int = 10

var health : int = 20
var boostStrength : float = 0.0 #How fast the boost is
var boostCooldown : float = 1.0
var launchPower : float = 0.25 #How fast launched items fly
var grabStrength : int = 1 #How strong the player is to grab bigger/heavier items
var rotSpeedLimit : float = 6.0 #How fast the max speed of the player is
var turnSpeed : float = 0.25 #How fast rotation builds up

var str_lv : int = 1
var chair_lv : int = 1
var armor : int = 0
var boost : int = 0

const strMax : int = 8
const chairMax : int = 7
const boostMax : int = 6

enum e_upg {STRENGTH, CHAIR, ARMOR, BOOST}

func getUpgradeRequirements(upg : int) -> Dictionary:
	match upg:
		e_upg.STRENGTH:
			match str_lv:
				1:
					return {e_items.TAPE : 4, e_items.PEN : 5}
				2:
					return {e_items.TAPE : 10, e_items.PEN : 8, e_items.TUBING : 5}
				3:
					return {e_items.TAPE : 15, e_items.PEN : 12, e_items.TUBING : 12,
					 e_items.WIRES : 5}
				4:
					return {e_items.TAPE : 25, e_items.PEN : 20, e_items.TUBING : 20,
					 e_items.WIRES : 10, e_items.CIRCUIT_BOARD : 2}
				5:
					return {e_items.TAPE : 30, e_items.PEN : 25, e_items.TUBING : 25,
					 e_items.WIRES : 20, e_items.CIRCUIT_BOARD : 5, e_items.CHIP : 2}
				6:
					return {e_items.TAPE : 40, e_items.PEN : 30, e_items.TUBING : 30,
					 e_items.WIRES : 25, e_items.CIRCUIT_BOARD : 10, e_items.CHIP : 5}
				7:
					return {e_items.TAPE : 50, e_items.PEN : 40, e_items.TUBING : 40,
					 e_items.WIRES : 35, e_items.CIRCUIT_BOARD : 15, e_items.CHIP : 10, e_items.OIL : 5}
		e_upg.CHAIR:
			match chair_lv:
				1:
					return {e_items.TAPE : 3, e_items.PEN : 5, e_items.OIL : 1}
				2:
					return {e_items.TAPE : 8, e_items.PEN : 8, e_items.TUBING : 3, e_items.OIL : 3}
				3:
					return {e_items.TAPE : 25, e_items.PEN : 15, e_items.TUBING : 12,
					 e_items.WIRES : 5, e_items.OIL : 5}
				4:
					return {e_items.TAPE : 40, e_items.PEN : 25, e_items.TUBING : 20,
					 e_items.WIRES : 15, e_items.OIL : 8}
				5:
					return {e_items.TAPE : 50, e_items.PEN : 35, e_items.TUBING : 30,
					 e_items.WIRES : 20, e_items.OIL : 12, e_items.CIRCUIT_BOARD : 10}
				6:
					return {e_items.TAPE : 60, e_items.PEN : 40, e_items.TUBING : 40,
					 e_items.WIRES : 30, e_items.OIL : 15, e_items.CIRCUIT_BOARD : 15, e_items.CHIP : 10}
		e_upg.ARMOR:
			match armor:
				0:
					return {e_items.TAPE : 4, e_items.PHONE_BOOK : 1}
				1:
					return {e_items.TAPE : 6, e_items.PHONE_BOOK : 2}
				2:
					return {e_items.TAPE : 8, e_items.PHONE_BOOK : 3}
				3:
					return {e_items.TAPE : 15, e_items.PHONE_BOOK : 6}
				4:
					return {e_items.TAPE : 30, e_items.PHONE_BOOK : 16}
				5,_:
					return {e_items.TAPE : 55, e_items.PHONE_BOOK : 40}
		e_upg.BOOST:
			match boost:
				0:
					return {e_items.TAPE : 5, e_items.SODA : 2, e_items.TUBING : 2}
				1:
					return {e_items.TAPE : 10, e_items.SODA : 6, e_items.TUBING : 4}
				2:
					return {e_items.TAPE : 15, e_items.SODA : 12, e_items.TUBING : 8}
				3:
					return {e_items.TAPE : 25, e_items.SODA : 20, e_items.TUBING : 16, e_items.WIRES : 5}
				4:
					return {e_items.TAPE : 40, e_items.SODA : 30, e_items.TUBING : 25, e_items.WIRES : 10, e_items.CIRCUIT_BOARD : 3}
				5:
					return {e_items.TAPE : 50, e_items.SODA : 40, e_items.TUBING : 30, e_items.WIRES : 10, e_items.CIRCUIT_BOARD : 8, e_items.CHIP : 2}
	return {}

func hasUpgradeRequirements(upg : int) -> bool:
	var req : Dictionary = getUpgradeRequirements(upg)
	for item : int in req.keys():
		if getItemCount(item) < req[item]:
			return false
	return true

func upgradePlayer(upg : int) -> bool:
	match upg:
		e_upg.STRENGTH:
			if str_lv == strMax:
				return false
			match str_lv:
				1:
					launchPower = 0.32
				2:
					grabStrength = 2
				3:
					launchPower = 0.38
				4:
					grabStrength = 3
				5:
					launchPower = 0.42
				6:
					grabStrength = 4
				7:
					launchPower = 0.5
			str_lv += 1
		e_upg.CHAIR:
			if chair_lv == chair_lv:
				return false
			match chair_lv:
				1:
					rotSpeedLimit = 8.0
				2:
					turnSpeed = 0.3
				3:
					rotSpeedLimit = 10.0
				4:
					turnSpeed = 0.35
				5:
					rotSpeedLimit = 12.0
				6:
					rotSpeedLimit = 16.0
			chair_lv += 1
		e_upg.ARMOR:
			armor += 1
		e_upg.BOOST:
			if boost == boostMax:
				return false
			match boost:
				0:
					boostStrength = 0.3
					boostCooldown = 1.0
				1:
					boostStrength = 0.35
					boostCooldown = 0.7
				2:
					boostStrength = 0.39
					boostCooldown = 0.5
				3:
					boostStrength = 0.42
					boostCooldown = 0.3
				4:
					boostStrength = 0.46
					boostCooldown = 0.25
				5:
					boostStrength = 0.5
					boostCooldown = 0.1
			boost += 1
	return true


var inventory : Dictionary[int, int] = {e_items.GLUE : 0, e_items.STAPLES : 0, e_items.TAPE : 0, e_items.PHONE_BOOK : 0,
 e_items.SODA : 0, e_items.CANDY : 0, e_items.TUBING : 0, e_items.WIRES : 0, e_items.CHIP : 0, e_items.CIRCUIT_BOARD : 0,
 e_items.PEN : 0, e_items.LASER_POINTER : 0, e_items.OIL : 0}

var hasLaserPointer : bool = false

func addItem(item : e_items) -> void:
	if inventory.has(item):
		inventory[item] += 1

func removeItem(item : e_items, quantity : int = 1) -> void:
	if inventory.has(item):
		inventory[item] -= quantity

func getItemCount(item : e_items) -> int:
	if inventory.has(item):
		return inventory[item]
	return 0

func getItemName(item : e_items) -> String:
	match item:
		e_items.GLUE:
			return "Glue"
		e_items.STAPLES:
			return "Staples"
		e_items.TAPE:
			return "Tape"
		e_items.PHONE_BOOK:
			return "Phone Book"
		e_items.SODA:
			return "Soda"
		e_items.CANDY:
			return "Energy Bar"
		e_items.TUBING:
			return "Silicone Tubing"
		e_items.WIRES:
			return "Wires"
		e_items.CHIP:
			return "Electronic Chip"
		e_items.CIRCUIT_BOARD:
			return "Circuit Board"
		e_items.PEN:
			return "Pen"
		e_items.OIL:
			return "Oil"
	return ""

func addMoney(qtty : int) -> void:
	money += qtty

func removeMoney(qtty : int) -> bool:
	if qtty > money:
		return false
	else:
		money = money - qtty
		return true
