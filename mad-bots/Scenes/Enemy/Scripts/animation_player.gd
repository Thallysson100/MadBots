extends AnimationPlayer
class_name Enemy_AnimationPlayer

@export var enemy_path : NodePath
@onready var enemy = get_node(enemy_path)

@export var spriteWalk_path : NodePath
@onready var spriteWalk = get_node(spriteWalk_path)

@export var spriteAttack_path : NodePath
@onready var spriteAttack = get_node(spriteAttack_path)

var can_play_new_animation := true  # Controle simples de bloqueio

func _ready() -> void:
	animation_started.connect(_on_animation_started)
	animation_finished.connect(_on_animation_finished)



var last_direction: bool

func flip() -> void:
	var dir = set_direction()
	spriteWalk.flip_h = dir
	spriteAttack.flip_h = dir

func set_direction() -> bool:
	if (enemy.velocity.x > 0):
		last_direction = false
		return false
	if (enemy.velocity.x < 0):
		last_direction = true
		return true;
	return last_direction


func _on_animation_started(anim_name: String) -> void:
	can_play_new_animation = true;
	spriteWalk.visible = false
	spriteAttack.visible = false

	match anim_name:
		"walk":
			spriteWalk.visible = true
		"attack":
			can_play_new_animation = false
			spriteAttack.visible = true

func _on_animation_finished(_anim_name: String) -> void:
	can_play_new_animation = true
