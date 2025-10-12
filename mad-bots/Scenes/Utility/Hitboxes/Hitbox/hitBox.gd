extends Area2D

@export_enum ("DisableForTime", "EnableForTime") var DisableHitBoxType = 0
@onready var collision = $CollisionShape2D
@onready var disableTimer = $TogleeTimer

var damage = 1
var disable = true
var angle = Vector2.ZERO
var knockback_amount = 1

func _ready():
	match DisableHitBoxType:
		0: #DisableForTime
			disable = true	
		1: #EnableForTime
			disable = false
	collision.call_deferred("set","disabled", not disable)
	disableTimer.timeout.connect(_on_disable_hit_box_timer_timeout)

func tempToggle():
	
	collision.call_deferred("set","disabled",disable)
	disableTimer.start()


func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set","disabled",not disable)

func set_knockback_property(damage_set: int, angle_set: Vector2, knockback_amount_set: int):
	damage = damage_set
	angle = angle_set
	knockback_amount = knockback_amount_set
	
