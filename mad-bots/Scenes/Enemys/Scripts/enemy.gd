extends CharacterBody2D
class_name Enemy

# Node references
@onready var player = get_tree().get_first_node_in_group("player")  # Get player reference from group

@export var attack_path : NodePath  # Path to the attack system node
@onready var attack = get_node(attack_path)  # Reference to attack system

@onready var animation = $Enemy_AnimationPlayer  # Animation controller

# Enemy properties
@export var speed: float = 100.0  # Movement speed
var direction_to_player : Vector2 = Vector2.ZERO  # Direction towards player


func _physics_process(delta):
	if not player:
		return  # Exit if player is not found

	# Calculate direction to player every frame
	direction_to_player = (player.global_position - global_position)
	move_or_attack(delta)

@export var attack_range: float = 50.0  # Minimum distance to attack

func move_or_attack(delta : float):
	var distance_to_player = direction_to_player.length()
	direction_to_player = direction_to_player.normalized()
	
	if attack.can_attack and distance_to_player <= attack.attack_range:
		# Attack when in range
		animation.play("attack")
		attack.start_attack(direction_to_player)
		
	elif animation.can_play_new_animation:
		# Move towards player	
		animation.process_sprite()
		animation.play("walk")
		velocity = speed * delta * direction_to_player
		move_and_collide(velocity)
