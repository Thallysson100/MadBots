extends CharacterBody2D
class_name Player

@export var player_velocity: int



@export var animationPlayer_path : NodePath
@onready var animation = get_node(animationPlayer_path)

var knockback: Vector2 = Vector2.ZERO
@export var knockback_recovery: float = 3.5



func _physics_process(_delta: float) -> void:
	movement()

func movement():
	
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
		
	move_and_slide()

func process_attack(damage, knockback_vector):
	knockback = knockback_vector
	print("o player foi atacado com ", damage, " de dano com direcao", knockback_vector)

func debbug():
	pass
