extends Area2D

@export var damage : int

@onready var player = get_tree().get_first_node_in_group("player")
@export var animationPlayer_path : NodePath
@onready var animation = get_node(animationPlayer_path)

@export var enemy_path : NodePath
@onready var enemy = get_node(enemy_path)

@onready var attack_cooldown = $AttackCooldown
@onready var attack_delay = $AttackDelay


@export var knockback_force : int = 0


var can_attack: bool = true
var player_detected : bool = false

func _ready():
	body_entered.connect(_on_area_2d_body_entered)
	body_exited.connect(_on_area_2d_body_exited)
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)
	attack_delay.timeout.connect(_on_attack_delay_timeout)
	
	
func generic_attack():
	can_attack = false
	animation.play("attack")
	attack_cooldown.start()
	attack_delay.start()


func _on_area_2d_body_entered(_body) -> void:
	player_detected = true
func _on_area_2d_body_exited(_body) -> void:
	player_detected = false

func _on_attack_cooldown_timeout():
	can_attack = true
func _on_attack_delay_timeout():
	if (player_detected):
		player.process_attack(damage, enemy.direction_to_player, knockback_force)
