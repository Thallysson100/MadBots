extends AnimationPlayer
class_name Player_AnimationPlayer

@export var player_path : NodePath
@onready var player = get_node(player_path)

@export var spriteWalk_path : NodePath
@onready var spriteWalk = get_node(spriteWalk_path)

@export var spriteIdle_path : NodePath
@onready var spriteIdle = get_node(spriteIdle_path)

@export var spriteTakingDamage_path : NodePath
@onready var spriteTakingDamage = get_node(spriteTakingDamage_path)


func _ready() -> void:
	animation_started.connect(_on_animation_started)



var flipped: bool
var last_result: bool = false
var z_pos : int = 0
var INTERVALE_Z : int = abs(RenderingServer.CANVAS_ITEM_Z_MIN)+abs(RenderingServer.CANVAS_ITEM_Z_MAX)

func process_sprite() -> void:
	var dir : bool = set_direction()
	spriteWalk.flip_h = dir
	spriteIdle.flip_h = dir
	spriteTakingDamage.flip_h = dir
	
	z_pos = RenderingServer.CANVAS_ITEM_Z_MIN + (int)(player.global_position.y / 20) % INTERVALE_Z
	
	spriteWalk.z_index = z_pos
	spriteIdle.z_index = z_pos
	spriteTakingDamage.z_index = z_pos

	if (flipped):
		spriteWalk.offset.x *= -1
		spriteIdle.offset.x *= -1
		spriteTakingDamage.offset.x *= -1
	

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
	spriteTakingDamage.visible = false

	match anim_name:
		"walk":
			spriteWalk.visible = true
		"idle":
			spriteIdle.visible = true
		"taking_damage":
			spriteTakingDamage.visible = true
