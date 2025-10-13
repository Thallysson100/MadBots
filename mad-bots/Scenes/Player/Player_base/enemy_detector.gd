extends Area2D

@export var gunsOrbiter_path : NodePath  ## Path to the orbital gun node
@onready var gunsOrbiter = get_node(gunsOrbiter_path)  # Reference

var enemies_in_range: Array = []

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		enemies_in_range.append(body)
	gunsOrbiter.start_fire()

func _on_body_exited(body: Node2D):
	enemies_in_range.erase(body)
	if enemies_in_range.is_empty():
		gunsOrbiter.stop_fire()

func closest_enemy_position() -> Vector2:
	if enemies_in_range.is_empty():
		return Vector2.ZERO
	
	var closest_enemy = enemies_in_range[0]
	var closest_dist = global_position.distance_to(closest_enemy.global_position)
	
	for enemy in enemies_in_range:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_enemy = enemy
	
	return closest_enemy.global_position
