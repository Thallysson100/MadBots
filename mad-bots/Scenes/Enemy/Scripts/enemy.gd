extends CharacterBody2D

@export var enemy_speed: int
@onready var player = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	var direction = position.direction_to(player.position)
	velocity = direction*enemy_speed
	move_and_slide()
	
