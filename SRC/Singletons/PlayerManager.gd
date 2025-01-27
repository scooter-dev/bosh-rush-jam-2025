extends Node

var player : Player

enum e_items {GLUE, STAPLES, TAPE, PHONE_BOOK, SODA, CANDY, TUBING, WIRES, CHIP, CIRCUIT_BOARD, PEN, LASER_POINTER}

var money : int = 5000

var boostStrength : float = 0.3 #How fast the boost is
var launchPower : float = 0.25 #How fast launched items fly
var grabStrength : float = 0.3 #How strong the player is to grab bigger/heavier items
var rotSpeedLimit : float = 6.0 #How fast the max speed of the player is
var turnSpeed : float = 0.25 #How fast rotation builds up

var glue : int = 0
var staples : int = 0
var tape : int = 0
var phoneBook : int = 0
var soda : int = 0
var candy : int = 0
var tubing : int = 0
var wires : int = 0
var chips : int = 0
var circuitBoards : int = 0
var pens : int = 0

var hasLaserPointer : bool = false
var hasBooster : bool = false
var boosterLevel : int = 1

func addItem(item : e_items) -> void:
	match item:
		e_items.GLUE:
			glue += 1
		e_items.STAPLES:
			staples += 1
		e_items.TAPE:
			tape += 1
		e_items.PHONE_BOOK:
			phoneBook += 1
		e_items.SODA:
			soda += 1
		e_items.CANDY:
			candy += 1
		e_items.TUBING:
			tubing += 1
		e_items.WIRES:
			wires += 1
		e_items.CHIP:
			chips += 1
		e_items.CIRCUIT_BOARD:
			circuitBoards += 1
		e_items.PEN:
			pens += 1
		e_items.LASER_POINTER:
			hasLaserPointer = true

func removeItem(item : e_items) -> void:
	match item:
		e_items.GLUE:
			glue -= 1
		e_items.STAPLES:
			staples -= 1
		e_items.TAPE:
			tape -= 1
		e_items.PHONE_BOOK:
			phoneBook -= 1
		e_items.SODA:
			soda -= 1
		e_items.CANDY:
			candy -= 1
		e_items.TUBING:
			tubing -= 1
		e_items.WIRES:
			wires -= 1
		e_items.CHIP:
			chips -= 1
		e_items.CIRCUIT_BOARD:
			circuitBoards -= 1
		e_items.PEN:
			pens -= 1

func addMoney(qtty : int) -> void:
	money += qtty

func removeMoney(qtty : int) -> bool:
	if qtty > money:
		return false
	else:
		money = money - qtty
		return true
