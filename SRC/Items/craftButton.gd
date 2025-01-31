extends MeshInstance3D

class_name CraftingButton

@onready var restingPosition : Vector3 = global_position

@export var upgrade : PlayerManager.e_upg
@export var lookAt : Node3D
@export var label : Label3D
@export var left : CraftingButton
@export var right : CraftingButton
@export var down : CraftingButton
@export var up : CraftingButton

func _ready() -> void:
	set_process(false)
	label.visible = false
	material_overlay.albedo_color.a = 0.0

func highlight() -> void:
	set_process(true)
	var tween : Tween = create_tween()
	label.visible = true
	tween.tween_property(self, "global_position:y", restingPosition.y + 0.1, 0.25)
	tween.tween_property(self.material_overlay, "albedo_color:a", 1.0, 0.25)

#STRENGTH, CHAIR, ARMOR, BOOST
func _process(delta: float) -> void:
	var txt : String
	match upgrade:
		PlayerManager.e_upg.STRENGTH:
			txt = "Strength level: %d\nPick up level: %d" % [PlayerManager.str_lv, PlayerManager.grabStrength]
		PlayerManager.e_upg.CHAIR:
			txt = "Chair Rotation Level: %d" % PlayerManager.chair_lv
		PlayerManager.e_upg.ARMOR:
			txt = "Armor: %d" % PlayerManager.armor
		PlayerManager.e_upg.BOOST:
			txt = "Booster level: %d" % PlayerManager.boost
	label.text = txt
	label.text += "\nRequirements:"
	var req : Dictionary = PlayerManager.getUpgradeRequirements(upgrade)
	for item : int in req.keys():
		label.text += "\n%s: %d/%d" % [PlayerManager.getItemName(item), req[item], PlayerManager.getItemCount(item)]

func unhighlight() -> void:
	set_process(false)
	var tween : Tween = create_tween()
	label.visible = false
	tween.tween_property(self, "global_position:y", restingPosition.y, 0.25)
	tween.tween_property(self.material_overlay, "albedo_color:a", 0.0, 0.1)
