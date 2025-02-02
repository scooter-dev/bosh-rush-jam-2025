extends MarginContainer

class_name InventoryMagin

var inventoryVisible: bool = false
var fadeCounter: float = 0.00;

# get items
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
@export var laserPointerCount: Label
@export var oilCount: Label



func changeCount(deltaCount: int, itemName: PlayerManager.e_items)-> void:
    pass

func showInventory()-> void:
    inventoryVisible = true
    fadeCounter = 1.00

func _process(delta):
    if inventoryVisible == true:
        fadeCounter-=delta

    if fadeCounter<= 0:
        inventoryVisible = false