extends Area2D


@onready var sprite = $Sprite2D
@onready var notify = $VisibleOnScreenNotifier2D


var direction = Vector2.ZERO
var speed = 400
var damage = 1
var knockback_amount = 1
var pierce = 1
var already_killed = false
var range_travel : float = 1
signal shake_camera(intensity, duration)
@export var shake_camera_on_hit = false
@export var shake_intensity = 5
@export var shake_duration = 0.1


func _ready():
	notify.screen_exited.connect(_on_screen_exited)
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	var distance : Vector2 = direction.normalized() * speed * delta
	range_travel -= distance.length()
	global_position += distance
	if (range_travel <= 0):
		kill()

func _on_body_entered(body):
	if body.is_in_group("world"): 
		kill()
	if body.is_in_group("enemy"):
		pierce -= 1
		if pierce <= 0:
			kill()

func _on_screen_exited():
	if not already_killed:
		kill()

func kill():
	already_killed = true
	if shake_camera_on_hit:
		emit_signal("shake_camera",shake_intensity,shake_duration)
	queue_free()
