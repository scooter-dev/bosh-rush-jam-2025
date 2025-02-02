extends MarginContainer


@export var boostIcon: Control
@export var shieldIcon: Control
@export var healthBar: TextureProgressBar

var health: int

func _start():
    PlayerInput.boost.connect(displayBoost)

func _process(delta):
    health = PlayerManager.health
    healthBar.set_value_no_signal(health)

func displayBoost():
    boostIcon.show()

func displayShield():
    shieldIcon.show()