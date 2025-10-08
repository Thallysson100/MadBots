extends CharacterBody2D
class_name Enemy



@onready var player = get_tree().get_first_node_in_group("player")

@export var animationPlayer_path : NodePath
@onready var animation = get_node(animationPlayer_path)

@export var attack_path : NodePath 
@onready var attack = get_node(attack_path)

@export var speed: float = 100.0


func _physics_process(delta):
	move_or_attack(delta)
	

func move_or_attack(_delta):
	if (attack.player_detected and attack.can_attack):
		attack.generic_attack() 
	elif (animation.can_play_new_animation):
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed	
		animation.process_sprite()
		animation.play("walk")
		move_and_slide()
	
		



	
