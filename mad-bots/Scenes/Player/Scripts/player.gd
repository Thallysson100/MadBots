extends CharacterBody2D
class_name Player

# Node Paths - These export variables allow you to assign nodes in the inspector
@export var animationPlayer_path : NodePath  ## Path to the AnimationPlayer node that controls player animations
@onready var animation = get_node(animationPlayer_path)  # Reference to the AnimationPlayer

@export var hurtbox_path : NodePath  ## Path to the Hurtbox area node that detects incoming attacks
@onready var hurtbox = get_node(hurtbox_path)  # Reference to the Hurtbox area
var knockback: Vector2 = Vector2.ZERO  # Stores the current knockback force applied to the player

@export var attack_path : NodePath  ## Path to the attack system node
@onready var gunsOrbiter = get_node(attack_path)  # Reference to attack system

@export var grab_area : NodePath  ## Path to the area used for grabbing items
@onready var grabArea = get_node(grab_area)  # Reference to the grab

#GUI
@onready var expBar = get_node("%ExperienceBar")  # Reference to the experience bar GUI element
@onready var lbl_level = get_node("%lbl_level")  # Reference to the level label GUI element





# Player Stats - Configurable properties that can be adjusted in the inspector
@export var player_velocity: int = 200  ## Base movement speed of the player in pixels per second
@export var knockback_recovery: float = 3.5  ## How quickly knockback force decays (higher = faster recovery)
@export var max_health: int = 1000  ## Maximum health points the player can have
@export var pickup_range: float = 100  ## Range within which the player can pick up items

var current_health: int = max_health  # Current health points (starts at max health)
var experience = 0
var experience_level = 1
var collected_experience = 0

func set_player_velocity(velocity_set : int):
	# Adjust the player's movement speed
	player_velocity = velocity_set  # Example velocity value

func set_max_health(health_set : int):
	# Adjust the player's maximum health and reset current health to max
	max_health = health_set
	if (current_health > max_health):
		current_health = max_health

func add_gun(gun_name: String):
	# Add a new gun to the player's attack system
	gunsOrbiter.add_gun(gun_name)


func _ready() -> void:
	# Connect the hurt signal from the hurtbox to our damage processing function
	hurtbox.hurt.connect(hurt)
	grabArea.get_child(0).shape.radius = pickup_range
	
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
		
	# Apply movement and handle collisions
	move_and_slide()

func hurt(damage, direction, knockback_amount):
	# Apply damage to player's health
	current_health -= damage
	
	# Calculate and apply knockback force in the specified direction
	knockback = direction * knockback_amount




func debbug():
	# Placeholder function for debugging purposes
	pass


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)
		
func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required:
		collected_experience -= exp_required-experience
		experience_level += 1
		print("Level:",experience_level)
		experience = 0
		exp_required = calculate_experiencecap()
		calculate_experience(0)
	else:
		experience += collected_experience
		collected_experience = 0

	set_expbar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif experience_level < 40:
		exp_cap = 95 * (experience_level - 19)*8
	else:
		exp_cap = 255 * (experience_level - 39)*12
		
	return exp_cap

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value
	lbl_level.text = str("Level: ", experience_level)

		
