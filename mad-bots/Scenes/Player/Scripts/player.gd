extends CharacterBody2D
class_name Player





@export var animationPlayer_path : NodePath
@onready var animation = get_node(animationPlayer_path)

@export var hurtbox_path : NodePath
@onready var hurtbox = get_node(hurtbox_path)
var knockback: Vector2 = Vector2.ZERO

@export var player_velocity: int = 200
@export var knockback_recovery: float = 3.5
@export var max_health: int = 1000
var current_health: int = max_health


func _ready() -> void:
	hurtbox.hurt.connect(process_attack)
	
func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta : float):
	
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov).normalized()

	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	
	animation.process_sprite()
	velocity = mov * player_velocity
	if (knockback != Vector2.ZERO):
		animation.play("taking_damage")
		velocity = knockback
	elif (mov != Vector2.ZERO):
		animation.play("walk")	
	else:
		animation.play("idle")
		
	move_and_collide(velocity*delta)

func process_attack(damage, angle, knockback_amount):
	current_health -= damage
	knockback = angle * knockback_amount
	

func debbug():
	pass
