extends CharacterBody2D
class_name Player

# Node Paths - These export variables allow you to assign nodes in the inspector
@export var animationPlayer_path : NodePath  ## Path to the AnimationPlayer node that controls player animations
@onready var animation = get_node(animationPlayer_path)  # Reference to the AnimationPlayer

@export var hurtbox_path : NodePath  ## Path to the Hurtbox area node that detects incoming attacks
@onready var hurtbox = get_node(hurtbox_path)  # Reference to the Hurtbox area
var knockback: Vector2 = Vector2.ZERO  # Stores the current knockback force applied to the player

# Player Stats - Configurable properties that can be adjusted in the inspector
@export var player_velocity: int = 200  ## Base movement speed of the player in pixels per second
@export var knockback_recovery: float = 3.5  ## How quickly knockback force decays (higher = faster recovery)
@export var max_health: int = 1000  ## Maximum health points the player can have
var current_health: int = max_health  # Current health points (starts at max health)

@export var attack_path : NodePath  ## Path to the attack system node
@onready var attack = get_node(attack_path)  # Reference to attack system
func _ready() -> void:
	# Connect the hurt signal from the hurtbox to our damage processing function
	hurtbox.hurt.connect(hurt)
	
func _physics_process(_delta: float) -> void:
	movement()

func movement():
	# Get input from movement keys (WASD or arrow keys)
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov).normalized()  # Normalize to prevent diagonal movement being faster

	
	
	# Update sprite direction and animations
	animation.process_sprite()
	
	# Set velocity based on player input
	velocity = mov * player_velocity
	
	# Handle different animation states based on player condition
	if knockback != Vector2.ZERO:
		# Gradually reduce knockback force over time
		knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
		# Play hit animation when knockback is active
		animation.custom_play("taking_damage")
		velocity = knockback  # Override movement with knockback force
	elif mov != Vector2.ZERO:
		# Play walk animation when moving
		animation.custom_play("walk")	
	else:
		# Play idle animation when stationary
		animation.custom_play("idle")
	if (attack.can_attack):
		# Start attack if attack input is detected
		attack.start_attack(Vector2.ZERO)  # Example angle to the right
		
	# Apply movement and handle collisions
	move_and_slide()

func hurt(damage, angle, knockback_amount):
	# Apply damage to player's health
	current_health -= damage
	
	# Calculate and apply knockback force in the specified direction
	knockback = angle * knockback_amount


func debbug():
	# Placeholder function for debugging purposes
	pass
