extends Area3D

class_name GrabArea

@export var player : Player

var grabbed : GrabbableProp = null

var selected : Node3D = null

func _ready() -> void:
	PlayerInput.SWL.connect(switchL)
	PlayerInput.SWR.connect(switchR)
	body_entered.connect(onBodyEntered)

func switchL() ->void:
	switchSelected(-1)

func switchR() ->void:
	switchSelected(1)

func onBodyEntered(body : Node3D) -> void:
	await get_tree().physics_frame
	if body is GrabbableProp:
		if body.weightClass <= PlayerManager.grabStrength and selected is GrabbableProp and selected.weightClass > PlayerManager.grabStrength:
			changeSelected(body)

func _physics_process(delta: float) -> void:
	if player.mode == Player.RUNNING and !grabbed:
		if selected == null:
			var ovlrBDS : Array = get_overlapping_bodies()
			var ovlrARS : Array = get_overlapping_areas()
			if ovlrBDS.size() > 0:
				for bd : Node3D in ovlrBDS:
					if bd is GrabbableProp:
						if bd.weightClass <= PlayerManager.grabStrength:
							selected = bd
				if selected == null:
					changeSelected(ovlrBDS[0])
			elif ovlrARS.size() > 0:
				changeSelected(ovlrARS[0])
		else:
			var ovlrBDS : Array = get_overlapping_bodies()
			var ovlrARS : Array = get_overlapping_areas()
			if selected.has_method("selected"):
				if selected is GrabbableProp:
					selected.selected(Color.GREEN if PlayerManager.grabStrength >= selected.weightClass else Color.RED)
				else:
					selected.selected()
			if !ovlrBDS.has(selected) and !ovlrARS.has(selected):
				changeSelected(null)
				if ovlrBDS.size() > 0:
					selected = ovlrBDS[0]
				elif ovlrARS.size() > 0:
					selected = ovlrARS[0]
	else:
		changeSelected(null)

func changeSelected(sel : Node3D) -> void:
	if selected and selected.has_method("unselected"):
		selected.unselected()
	selected = sel
	if selected and selected.has_method("selected"):
		if selected is GrabbableProp:
			selected.selected(Color.GREEN if PlayerManager.grabStrength >= selected.weightClass else Color.RED)
		else:
			selected.selected()

func switchSelected(dir : int) -> void:
	if selected == null:
		return
	var ovlrBDS : Array = get_overlapping_bodies()
	var ovlrARS : Array = get_overlapping_areas()
	match dir:
		1:
			if ovlrBDS.has(selected):
				var index : int = ovlrBDS.find(selected)
				if index == ovlrBDS.size() - 1:
					changeSelected(ovlrBDS[0])
				else:
					changeSelected(ovlrBDS[index + 1])
			elif ovlrARS.has(selected):
				var index : int = ovlrARS.find(selected)
				if index == ovlrARS.size() - 1:
					changeSelected(ovlrARS[0])
				else:
					changeSelected(ovlrARS[index + 1])
			else:
				changeSelected(ovlrBDS[0] if ovlrBDS.size() > 0 else ovlrARS[0] if ovlrARS.size() > 0 else null)
		-1:
			if ovlrBDS.has(selected):
				var index : int = ovlrBDS.find(selected)
				if index == 0:
					changeSelected(ovlrBDS[ovlrBDS.size() - 1])
				else:
					changeSelected(ovlrBDS[index - 1])
			elif ovlrARS.has(selected):
				var index : int = ovlrARS.find(selected)
				if index == 0:
					changeSelected(ovlrARS[ovlrARS.size() - 1])
				else:
					changeSelected(ovlrARS[index - 1])
			else:
				changeSelected(ovlrBDS[0] if ovlrBDS.size() > 0 else ovlrARS[0] if ovlrARS.size() > 0 else null)

func interact() ->void:
	match player.mode:
		Player.RUNNING:
			if !grabbed:
				if !selected:
					return
				if selected is GrabbableProp:
					if selected.weightClass > PlayerManager.grabStrength:
						return
					selected.freeze = true
					selected.setNoCol()
					selected.reparent(self)
					selected.position = Vector3()
					selected.rotation = Vector3()
					if selected.grabPoint:
						selected.rotation = selected.grabPoint.rotation
						selected.position = selected.grabPoint.position
					grabbed = selected
					changeSelected(null)
					return
				elif selected.has_method("onInteracted"):
					selected.onInteracted(player)
					return
				if selected is InteractionArea:
					selected.onInteracted(player)
					return
			else:
				grabbed.reparent(WorldManager.currentLevel)
				grabbed.setCol()
				grabbed.freeze = false
				grabbed = null
				print("Drop")

func throw(dir : Vector3, str : float) -> void:
	if grabbed:
		grabbed.reparent(WorldManager.currentLevel)
		grabbed.freeze = false
		grabbed.apply_central_impulse(dir * str)
		grabbed.thrown(player)
		grabbed = null
