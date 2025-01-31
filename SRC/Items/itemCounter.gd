extends MeshInstance3D

@export var item : PlayerManager.e_items
@onready var text : Label3D = $Label3D
@export var cTable : CraftingTable

func _ready() -> void:
	text.visible = false
	set_process(false)
	cTable.started.connect(cTableStarted)
	cTable.stopped.connect(cTableStopped)

func cTableStarted() -> void:
	text.visible = true
	set_process(true)

func cTableStopped() -> void:
	text.visible = false
	set_process(false)

func _process(delta: float) -> void:
	text.text = PlayerManager.getItemName(item) + "\n%d" % PlayerManager.getItemCount(item)
