extends Area3D

class_name ItemDrop

@export var item : PlayerManager.e_items
@export_category("Meshes")
@export var glue_bottle: MeshInstance3D
@export var staple_box: MeshInstance3D
@export var tape: MeshInstance3D
@export var pen: MeshInstance3D
@export var phone_book: MeshInstance3D
@export var soda_can: MeshInstance3D
@export var candy: MeshInstance3D
@export var funnel: MeshInstance3D
@export var tubing: MeshInstance3D
@export var wires: MeshInstance3D
@export var chip: MeshInstance3D
@export var circuit_board: MeshInstance3D
@export var oil: MeshInstance3D

@onready var dss : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
var ray : PhysicsRayQueryParameters3D
var velocity : Vector3

func _ready() -> void:
	ray = PhysicsRayQueryParameters3D.new()
	ray.collision_mask = 1
	showMesh()

var picked : bool = false
func _process(delta: float) -> void:
	meshHolder.rotate_y(delta * 2.0)
	if picked:
		meshHolder.global_position = lerp(meshHolder.global_position, player.global_position, delta * 16.0)
		if meshHolder.global_position.distance_squared_to(player.global_position) < 0.025:
			queue_free()

var freezeTimer : float = 1.0
func _physics_process(delta: float) -> void:
	if velocity.length_squared() > 0.01:
		freezeTimer = 1.0
		ray.from = global_position
		ray.to = global_position + velocity * delta * 1.1
		
		var res : Dictionary = dss.intersect_ray(ray)
		if res.has("collider"):
			velocity *= 0.5
			velocity = velocity.bounce(res.normal)
		global_position += velocity * delta
		velocity.y -= 9.8 * delta
	else:
		freezeTimer -= delta
		if freezeTimer < 0.002:
			set_physics_process(false)

func showMesh() -> void:
	hideAllMeshes()
	match item:
		PlayerManager.e_items.GLUE:
			glue_bottle.visible = true
		PlayerManager.e_items.STAPLES:
			staple_box.visible = true
		PlayerManager.e_items.TAPE:
			tape.visible = true
		PlayerManager.e_items.PHONE_BOOK:
			phone_book.visible = true
		PlayerManager.e_items.SODA:
			soda_can.visible = true
		PlayerManager.e_items.CANDY:
			candy.visible = true
		PlayerManager.e_items.TUBING:
			tubing.visible = true
		PlayerManager.e_items.WIRES:
			wires.visible = true
		PlayerManager.e_items.CHIP:
			chip.visible = true
		PlayerManager.e_items.CIRCUIT_BOARD:
			circuit_board.visible = true
		PlayerManager.e_items.PEN:
			pen.visible = true
		PlayerManager.e_items.OIL:
			oil.visible = true

@export var meshHolder: Node3D

func hideAllMeshes() -> void:
	for m : MeshInstance3D in meshHolder.get_children():
		m.visible = false

var player : Player
func _on_body_entered(body: Node3D) -> void:
	PlayerManager.addItem(item)
	collision_mask = 0
	picked = true
	player = body
	meshHolder.top_level = true
