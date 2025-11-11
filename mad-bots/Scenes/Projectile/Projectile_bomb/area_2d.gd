extends Area2D


var damage = 1
var disable = true
var direction = Vector2.ZERO
var knockback_amount = 1
var attacker_position = Vector2.ZERO

signal enabled
@onready var collision = $CollisionShape2D
@onready var sprite = $Sprite2D

@export var enable_time = 0.1
@export var sprite_enable_time = 0.1

var enabled_time: float = 0.0
var sprite_enabled_time: float = 0.0

func _process(delta):
	if not disable:
		enabled_time -= delta
		if enabled_time <= 0:
			disable = true
			collision.call_deferred("set","disabled",true)
			emit_signal("enabled")
	if sprite.visible:
		sprite_enabled_time -= delta
		if sprite_enabled_time <= 0:
			sprite.visible = false
		

func set_knockback_property(_damage: int, _direction: Vector2, _knockback_amount: float, _attacker_position: Vector2) -> void:
	damage = _damage
	direction = _direction
	knockback_amount = _knockback_amount
	attacker_position = _attacker_position

func set_size(size: float) -> void:
	var shape = collision.shape
	if shape is CircleShape2D:
		shape.radius = size / 2
		collision.shape = shape
	sprite.scale = Vector2.ONE * (size / sprite.texture.get_size().x)

func enable():
	disable = false
	enabled_time = enable_time
	sprite_enabled_time = sprite_enable_time
	collision.call_deferred("set","disabled",false)
	sprite.visible = true
