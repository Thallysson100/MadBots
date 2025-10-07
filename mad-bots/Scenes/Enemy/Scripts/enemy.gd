extends CharacterBody2D
class_name Enemy



@onready var player = get_tree().get_first_node_in_group("player")

@export var animationPlayer_path : NodePath
@onready var animation = get_node(animationPlayer_path)

@export var attack_cooldown_path : NodePath
@onready var attack_cooldown = get_node(attack_cooldown_path)

@export var attack_delay_path : NodePath
@onready var attack_delay = get_node(attack_delay_path)

@export var player_detector_path : NodePath 
@onready var player_detector = get_node(player_detector_path)

@export var speed: float = 100.0

var can_attack: bool = true
var player_detected : bool = false

func _ready():
	player_detector.body_entered.connect(_on_area_2d_body_entered)
	player_detector.body_exited.connect(_on_area_2d_body_exited)
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)
	attack_delay.timeout.connect(_on_attack_delay_timeout)
	
func _physics_process(delta):
	move_or_attack(delta)
	

func move_or_attack(_delta):
	var direction = (player.global_position - global_position)
	if (not player_detected and animation.can_play_new_animation):
		velocity = direction.normalized() * speed
		move_and_slide()

		animation.flip()
		animation.play("walk")
	elif (can_attack):
		generic_attack()
		
func generic_attack():
	can_attack = false
	animation.play("attack")
	attack_cooldown.start()
	attack_delay.start()

func attack()->void:
	print("O player foi estuprado")

func _on_area_2d_body_entered(_body) -> void:
	player_detected = true
func _on_area_2d_body_exited(_body) -> void:
	player_detected = false

func _on_attack_cooldown_timeout():
	can_attack = true
func _on_attack_delay_timeout():
	if (player_detected):
		attack()



	
