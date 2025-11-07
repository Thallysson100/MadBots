extends Node2D

# Node references for the attack system components
@onready var attack_area = $Attack_area          # Area that actually applies damage/knockback
@onready var delay = $Delay_timer                # Timer to control attack timing
@onready var cooldown = $Cooldown_timer        # Timer to manage attack cooldowns

# Export variables to configure attack properties in the inspector
@export var damage : int                         # Damage dealt by the attack
@export var knockback_force : int = 0            # Force applied for knockback effect
@export var attack_range : float = 50.0               # Range within which the attack can be initiated


var can_attack = true						# Flag to control if attack can be initiated
# Signal emitted when player enters detection range and attack can begin

func _ready():
	# Connect signals to their respective handler functions
	delay.timeout.connect(_on_delay_timeout)
	cooldown.timeout.connect(_on_attack_cooldown_timeout)


# Initiates the attack sequence with specified angle
func start_attack(angle):
	# Prevent further attacks until cooldown completes
	can_attack = false
	cooldown.start()
	# Configure the attack area with damage and knockback properties
	attack_area.set_knockback_property(damage, angle, knockback_force)
	
	# Start delay timer before attack area becomes active
	delay.start()

# Called when the delay timer finishes
func _on_delay_timeout():
	# Activate the attack area to apply damage/knockback
	attack_area.tempToggle()

# Called when the cooldown timer finishes
func _on_attack_cooldown_timeout():
	# Allow new attacks to be initiated
	can_attack = true
