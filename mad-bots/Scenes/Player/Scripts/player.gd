extends CharacterBody2D

@export var player_velocity: int


func _physics_process(_delta: float) -> void:
	movement()

func movement():
	
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var direction = Vector2(x_mov, y_mov).normalized()
	velocity = direction * player_velocity
	move_and_slide()
