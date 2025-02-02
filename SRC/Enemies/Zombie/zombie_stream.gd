extends AudioStreamPlayer3D


@export var zombie : Zombie
@export var attack_area: ZombieAttackArea


const growls : Array[AudioStream] = [preload("res://Assets/Audio/ZombieSounds/growl1.ogg"), preload("res://Assets/Audio/ZombieSounds/growl3.ogg"), preload("res://Assets/Audio/ZombieSounds/growl4.ogg"),  preload("res://Assets/Audio/ZombieSounds/growl5.ogg")]
const atkSound : Array[AudioStream] =  [preload("res://Assets/Audio/ZombieSounds/growl5.ogg"),preload("res://Assets/Audio/ZombieSounds/growl6.ogg"),preload("res://Assets/Audio/ZombieSounds/growl7.ogg"), preload("res://Assets/Audio/ZombieSounds/growl8.ogg")]
func _ready() -> void:
	finished.connect(onFinished)
	attack_area.playerInArea.connect(attackSound)

func onFinished() -> void:
	if is_processing():
		tmr = randf_range(0.5, 8)

@onready var tmr : float = randf_range(0,4)
var block : bool = false
func _process(delta: float) -> void:
	if !zombie.isDead:
		if tmr > 0.001:
			tmr -= delta
		elif !playing:
			pitch_scale = randf_range(0.9,1.1)
			stream = growls.pick_random()
			play()
	else:
		set_process(false)
		stop()

func attackSound() -> void:
	pitch_scale = randf_range(0.9,1.1)
	stream = atkSound.pick_random()
	play()
