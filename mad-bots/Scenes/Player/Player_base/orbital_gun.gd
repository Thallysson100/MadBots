extends Node2D


@export var guns_available: Dictionary = {
	"gun_test" : preload("res://Scenes/Player/Guns/gun_test.tscn"),
}
@export var orbit_radius: float = 200
@export var orbit_speed: float = 0.25  # Rotações por segundo

@onready var player = get_parent()

var array_guns_count: int = 0
var target_position: Vector2 = Vector2.ZERO

func add_gun(gun_name: String):
	if guns_available.has(gun_name):
		var gun_instance = guns_available[gun_name].instantiate()
		array_guns_count += 1
		add_child(gun_instance)
	else:
		print("Gun not found in available guns.")
		return

	var i : int = 0
	for gun in self.get_children():
		var angle = i * TAU / array_guns_count
		gun.set_meta("angle", angle)
		gun.rotation = angle
		gun.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * orbit_radius
		i += 1

	

func _ready():
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
	
func update_guns(atributte: String, value: float):
	for gun in self.get_children():
		gun.gun_update(atributte, value)
