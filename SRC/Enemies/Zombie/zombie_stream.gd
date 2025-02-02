extends AudioStreamPlayer3D


@export var zombie : Zombie
@export var attack_area: ZombieAttackArea


const growls : Array[AudioStream] = [preload("res://Assets/Audio/ZombieSounds/growl1.ogg"), preload("res://Assets/Audio/ZombieSounds/growl3.ogg"), preload("res://Assets/Audio/ZombieSounds/growl4.ogg"),  preload("res://Assets/Audio/ZombieSounds/growl5.ogg")]
const atkSound : Array[AudioStream] =  [preload("res://Assets/Audio/ZombieSounds/growl5.ogg"),preload("res://Assets/Audio/ZombieSounds/growl6.ogg"),preload("res://Assets/Audio/ZombieSounds/growl7.ogg"), preload("res://Assets/Audio/ZombieSounds/growl8.ogg")]
const speech : Array[AudioStream] = [preload("res://Assets/Audio/ZombieSounds/Speech/annualreport.ogg"), preload("res://Assets/Audio/ZombieSounds/Speech/bighappyfamily.ogg"), preload("res://Assets/Audio/ZombieSounds/Speech/circleback.ogg"), preload("res://Assets/Audio/ZombieSounds/Speech/coffee.ogg"), preload("res://Assets/Audio/ZombieSounds/Speech/company.ogg"), preload("res://Assets/Audio/ZombieSounds/Speech/companyislikeafamily.ogg"), preload("res://Assets/Audio/ZombieSounds/Speech/megatronsubsidized.ogg"), preload("res://Assets/Audio/ZombieSounds/Speech/metric.ogg"), preload("res://Assets/Audio/ZombieSounds/Speech/planningcommittee.ogg"), preload("res://Assets/Audio/ZombieSounds/Speech/synergy.ogg")]

func _ready() -> void:
	finished.connect(onFinished)
	attack_area.playerInArea.connect(attackSound)
	zombie

func onFinished() -> void:
	if is_processing():
		tmr = randf_range(2, 20)

@onready var tmr : float = randf_range(0,12)
var block : bool = false
func _process(delta: float) -> void:
	if !zombie.isDead:
		if tmr > 0.001:
			tmr -= delta
		elif !playing:
			pitch_scale = randf_range(0.9,1.1)
			if randf_range(0,1) > 0.7:
				stream = speech.pick_random()
			else:
				stream = growls.pick_random()
			play()
	else:
		set_process(false)
		pitch_scale = 0.6
		volume_linear = 1.7
		stream = preload("res://Assets/Audio/SFX/slap.ogg")
		play()

func attackSound() -> void:
	if !zombie.isDead:
		pitch_scale = randf_range(0.9,1.1)
		stream = atkSound.pick_random()
		play()
