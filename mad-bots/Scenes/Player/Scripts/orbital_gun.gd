extends Node2D


@export var guns_available: Dictionary = {
	"gun_test" : preload("res://Scenes/Player/Guns/gun_test.tscn"),
}
@export var orbit_radius: float = 150.0
@export var orbit_speed: float = 0.25  # Rotações por segundo

@onready var player = get_parent()

var array_guns: Array[Node2D] = []
var target_position: Vector2 = Vector2.ZERO

func add_gun(gun_name: String):
	if guns_available.has(gun_name):
		var gun_instance = guns_available[gun_name].instantiate()
		array_guns.append(gun_instance)
		add_child(gun_instance)
	else:
		print("Gun not found in available guns.")
		return

	var orbit_count = array_guns.size()
	var i : int = 0
	for gun in self.get_children():
		var angle = i * TAU / orbit_count
		gun.set_meta("angle", angle)
		gun.rotation = angle
		gun.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * orbit_radius
		i += 1

	

func _ready():
	add_gun("gun_test")
	add_gun("gun_test")
	add_gun("gun_test")
	add_gun("gun_test")
	add_gun("gun_test")
	add_gun("gun_test")

func start_fire():
	for gun in self.get_children():
		gun.can_fire = true

func stop_fire():
	for gun in self.get_children():
		gun.can_fire = false


func _process(delta):
	for gun in self.get_children():
		var angle = gun.get_meta("angle") + orbit_speed * delta
		gun.set_meta("angle", angle)
		gun.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * orbit_radius
		var target_direction = (target_position - gun.get_child(1).global_position).normalized()
		gun.target_direction = target_direction
		gun.rotation = target_direction.angle()
	
