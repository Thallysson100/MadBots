extends CharacterBody2D
class_name Enemy

# Node references
@onready var player = get_tree().get_first_node_in_group("player")  # Get player reference from group

@export var attack_path : NodePath  ## Path to the attack system node
@onready var attack = get_node(attack_path)  # Reference to attack system

@export var animation_path : NodePath
@onready var animation = get_node(animation_path)   # Animation controller
@onready var hurtbox = $HurtBox  # Hurtbox area

# Enemy properties
@export var speed: float   ## Movement speed
@export var knockback_recovery: float  ## How quickly knockback force decays (higher = faster recovery)
@export var max_health: int  ## Maximum health points the enemy can have
@export var experience_reward: int  ## Experience given to player upon defeat

@onready var experience_gem_scene : PackedScene = preload("res://Scenes/Objects/experience_gem.tscn")

var direction_to_player : Vector2 = Vector2.ZERO  # Direction towards player
var knockback: Vector2 = Vector2.ZERO  # Stores the current knockback force applied to the enemy
var current_health: int  # Current health points (starts at max health)
func _ready() -> void:
	current_health = max_health
	# Connect the hurt signal from the hurtbox to our damage processing function
	hurtbox.hurt.connect(hurt)
	# Connect the death animation finished signal to queue_free the enemy
	animation.death_animation_finished.connect(_on_dead)

func _physics_process(delta : float) -> void:
	if not player:
		return  # Exit if player is not found

	# Calculate direction to player every frame
	direction_to_player = (player.global_position - global_position)
	move_or_attack(delta)


func move_or_attack(_delta : float):
	var distance_to_player = direction_to_player.length()
	direction_to_player = direction_to_player.normalized()
	

	velocity = Vector2.ZERO
	if knockback != Vector2.ZERO:
		knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
		# Play hit animation when knockback is active
		animation.custom_play("taking_damage")
		velocity = knockback  # Override movement with knockback force

	elif attack.can_attack and distance_to_player <= attack.attack_range:
		# Attack when in range
		animation.custom_play("attack")
		attack.start_attack(direction_to_player)
		
	elif (animation.can_play_new_animation):
		# Move towards player	
		velocity = speed * direction_to_player
		animation.process_sprite()
		animation.custom_play("walk")	
	move(distance_to_player)

func move(_distance_to_player: float) -> void:
	move_and_slide()
		

func hurt(damage, _direction, knockback_amount):
	# Apply damage to player's health
	current_health -= damage
	
	# Calculate and apply knockback force in the specified direction
	knockback = -direction_to_player * knockback_amount
	if current_health <= 0:
		attack.can_attack = false
		animation.custom_play("death")

func _on_dead():
	var gem_experience = experience_gem_scene.instantiate()
	gem_experience.global_position = global_position
	gem_experience.experience = experience_reward
	get_tree().root.add_child(gem_experience)
	queue_free()

		
