extends AnimationPlayer
class_name Enemy_AnimationPlayer

@export var enemy_path : NodePath
@onready var enemy = get_node(enemy_path)

@export var spriteWalk_path : NodePath
@onready var spriteWalk = get_node(spriteWalk_path)

@export var spriteAttack_path : NodePath
@onready var spriteAttack = get_node(spriteAttack_path)

var can_play_new_animation := true  # Controle simples de bloqueio
var flipped: bool
var last_result: bool = false
var z_pos : int = 0
var INTERVALE_Z : int = abs(RenderingServer.CANVAS_ITEM_Z_MIN)+abs(RenderingServer.CANVAS_ITEM_Z_MAX)


func _ready() -> void:
	animation_started.connect(_on_animation_started)
	animation_finished.connect(_on_animation_finished)



var last_direction: bool

func process_sprite() -> void:
	var dir = set_direction()
	
	spriteWalk.flip_h = dir
	spriteAttack.flip_h = dir
	
	#preciso consertar, cooredanas negativas inverte
	z_pos = RenderingServer.CANVAS_ITEM_Z_MIN + (int) (abs(enemy.global_position.y) / 20) % INTERVALE_Z

	spriteWalk.z_index = z_pos
	spriteAttack.z_index = z_pos

	if (flipped):
		spriteWalk.offset.x *= -1
		spriteAttack.offset.x *= -1

func set_direction() -> bool:
	if (enemy.velocity.x > 0):
		if (last_result): flipped = true
		else: flipped = false	
		last_result = false
		return false
	if (enemy.velocity.x < 0):
		if (not last_result): flipped = true
		else: flipped = false	
		last_result = true
		return true;
	flipped = false
	return last_result


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
