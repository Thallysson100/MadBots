extends CharacterBody2D
class_name Player

@export var player_velocity: int
@export var target_path: NodePath

@onready var animation = $AnimationPlayer


func _physics_process(_delta: float) -> void:
	movement()

func movement():
	
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)

	velocity = mov.normalized() * player_velocity
	animation.flip()

	if (velocity != Vector2.ZERO):
		animation.play("walk")
	else:
		animation.play("idle")
		
	move_and_slide()
