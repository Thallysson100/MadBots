extends CharacterBody2D
class_name Player

@export var player_velocity: int


@onready var enemys = get_tree().get_nodes_in_group("enemy")

@export var animationPlayer_path : NodePath
@onready var animation = get_node(animationPlayer_path)

func _ready():
	for enemy in enemys:
		enemy.get_node("Attack").attacked_player.connect(_on_attacked_player)



func _physics_process(_delta: float) -> void:
	movement()

func movement():
	
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov).normalized()

	velocity = mov * player_velocity
	animation.process_sprite()

	if (velocity != Vector2.ZERO):
		animation.play("walk")
	else:
		animation.play("idle")
		
	move_and_slide()

func _on_attacked_player(damage):
	print("atacou o player com ", damage, " de dano")

func debbug():
	pass
