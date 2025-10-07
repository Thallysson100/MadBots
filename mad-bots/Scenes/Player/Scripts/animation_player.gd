extends AnimationPlayer
class_name Player_AnimationPlayer

@export var player_path : NodePath
@onready var player = get_node(player_path)

@export var spriteWalk_path : NodePath
@onready var spriteWalk = get_node(spriteWalk_path)

@export var spriteIdle_path : NodePath
@onready var spriteIdle = get_node(spriteIdle_path)


func _ready() -> void:
	animation_started.connect(_on_animation_started)



var flipped: bool
var last_result: bool = false

func flip() -> void:
	var dir = set_direction()
	spriteWalk.flip_h = dir
	spriteIdle.flip_h = dir
	if (flipped):
		spriteWalk.offset.x *= -1
		spriteIdle.offset.x *= -1

func set_direction() -> bool:
	if (player.velocity.x > 0):
		if (last_result): flipped = true
		else: flipped = false	
		last_result = false
		return false
	if (player.velocity.x < 0):
		if (not last_result): flipped = true
		else: flipped = false	
		last_result = true
		return true;
	flipped = false
	return last_result


func _on_animation_started(anim_name: String) -> void:
	spriteWalk.visible = false
	spriteIdle.visible = false

	match anim_name:
		"walk":
			spriteWalk.visible = true
		"idle":
			spriteIdle.visible = true
