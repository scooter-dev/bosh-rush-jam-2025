extends MarginContainer

enum e_items {GLUE, STAPLES, TAPE, PHONE_BOOK, SODA, CANDY, TUBING, WIRES, CHIP, CIRCUIT_BOARD, PEN, LASER_POINTER, OIL}

@export var inventoryGrid: GridContainer
#HUD Items List
@export var glueCount: Label
@export var stapleCount: Label
@export var tapeCount: Label
@export var phoneBookCount: Label
@export var sodaCount: Label
@export var candyCount: Label
@export var tubingCount: Label
@export var wiresCount: Label
@export var chipCount: Label
@export var circuitboardCount: Label
@export var penCount: Label
# @export var laserPointerCount: Label
@export var oilCount: Label

var inventoryVisible: bool = false
var fadeCounter: float = 0.00;

func _ready():
	# signal from player when inv update to change count on hud
	PlayerManager.updateHudCount.connect(changeCount)


func changeCount(newCount: int, itemName: PlayerManager.e_items) -> void:
	var currentLabel: Label
	match itemName:
		e_items.GLUE:
			currentLabel = glueCount
		e_items.STAPLES:
			currentLabel = stapleCount
		e_items.PHONE_BOOK:
			currentLabel = phoneBookCount
		e_items.SODA:
			currentLabel = sodaCount
		e_items.CANDY:
			currentLabel = candyCount
		e_items.TUBING:
			currentLabel = tubingCount
		e_items.CHIP:
			currentLabel = chipCount
		e_items.CIRCUIT_BOARD:
			currentLabel = circuitboardCount
		e_items.OIL:
			currentLabel = oilCount
		e_items.PEN:
			currentLabel = penCount
		e_items.WIRES:
			currentLabel = wiresCount
		e_items.TAPE:
			currentLabel = tapeCount
	currentLabel.set_text(String.num(newCount))
	print_debug("yum, a"+ PlayerManager.getItemName(itemName)+ ". Now you have "+String.num(newCount))
	if newCount > 0:
		currentLabel.get_parent().show()
	else:
		currentLabel.get_parent().hide()


func showInventory() -> void:
	inventoryVisible = true
	inventoryGrid.show()
	fadeCounter = 1.00

func _process(delta):
	pass
	# if inventoryVisible == true:
	# 	fadeCounter -= delta

	# if fadeCounter <= 0:
	# 	inventoryGrid.hide()
	# 	inventoryVisible = false
