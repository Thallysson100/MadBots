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
@onready var healthbar = get_node("%Healthbar") # Reference to the health bar GUI element
@onready var levelPanel = get_node("%LevelUp")  # Reference to the level-up panel GUI element


# Player Stats - Configurable properties that can be adjusted in the inspector
@export var player_velocity: int = 200  ## Base movement speed of the player in pixels per second
@export var knockback_recovery: float = 3.5  ## How quickly knockback force decays (higher = faster recovery)
@export var max_health: int = 1000  ## Maximum health points the player can have
@export var pickup_range: float = 100  ## Range within which the player can pick up items
@export var initial_gun: String = "Futuristic Chicago"  ## Name of the initial gun to equip

var current_health
var atributtes_percentage : Dictionary = { # Dictionary to track percentage-based upgrades
	"fire_rate" : 1.0,
	"fire_range" : 1.0,
	"knockback_amount" : 1.0,
	"damage" : 1.0,
	"projectile_speed" : 1.0,
	"pierce": 1.0
}

func _ready() -> void:
	# Connect the hurt signal from the hurtbox to our damage processing function
	hurtbox.hurt.connect(hurt)
	grabArea.get_child(0).shape.radius = pickup_range
	healthbar.init_health(max_health)
	current_health = max_health
	
func _physics_process(_delta: float) -> void:
	movement()

func movement():
	# Get input from movement keys (WASD or arrow keys)
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov).normalized()  # Normalize to prevent diagonal movement being faster
	
	# Update sprite direction and animations
	animation.process_sprite()
	
	# Set velocity based on player input and ensure it reflects the updated player_velocity
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
	healthbar.health = current_health

	if current_health <= 0:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Utility/GameOver/game_over.tscn")
		call_deferred("queue_free")
		return
	# Calculate and apply knockback force in the specified direction
	knockback = direction * knockback_amount


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		expBar.calculate_experience(gem_exp)
		

## UPGRADE FUNCTIONS ##

# a item_option emits the signal selected_upgrade with the upgrade name as argument
func upgrade_character(upgrade : String):
	for i in range(UpgradesDb.UPGRADES[upgrade]["functions"].size()):
		callv(UpgradesDb.UPGRADES[upgrade]["functions"][i], UpgradesDb.UPGRADES[upgrade]["arguments"][i])
	
	# After upgrading, hide the level-up panel
	levelPanel.hide_levelup_panel()

func heal_player(heal_amount : int):
	current_health += heal_amount
	current_health = min(current_health, max_health)
	healthbar.health = current_health

func update_player_velocity(percentage : float):
	player_velocity += (int)(player_velocity * percentage)

func update_max_health(health_amount : int):
	# Adjust the player's maximum health and reset current health to max
	max_health = (max_health + health_amount) if (max_health + health_amount > 0) else 1
	current_health = (current_health) if (max_health > current_health) else max_health
	healthbar.update_max_health(health_amount)

func add_gun(gun_name: String):
	gunsOrbiter.add_gun(gun_name, atributtes_percentage)

func update_guns(atributte: String, percentage : float):
	atributtes_percentage[atributte] += atributtes_percentage[atributte] * percentage
	gunsOrbiter.update_guns(atributte, atributtes_percentage[atributte])

func update_pickup_range(range_amount: float):
	pickup_range += pickup_range * range_amount
	grabArea.get_child(0).shape.radius = pickup_range
