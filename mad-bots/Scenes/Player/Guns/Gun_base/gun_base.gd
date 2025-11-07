extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var projectile_spawn_point: Marker2D = $ProjectileSpawnPoint
@onready var enemyDetector = $EnemyDetector


@export var damage: int = 100 ## Damage dealt by the gun
@export var fire_rate: float = 0.5 ## Time in seconds between shots
@export var pierce: int = 1 ## How many enemies the projectile can pierce through
@export var projectile_speed: float = 4000 ## Speed of the projectile
@export var fire_range : float = 400
@export var knockback_amount: float = 500 ## Knockback force applied to enemies hit
var current_cooldown: float = 0.0
var can_fire = false


@export var projectiles_available: Dictionary = {
	"projectile_test" : preload("res://Scenes/Projectile/projectile_test.tscn"),
}
var projectile_scene: PackedScene  ## The projectile scene to instantiate

func _ready():
	#temporario, depois criar função para mudar o projétil na interface
	set_current_projectile("projectile_test")
	enemyDetector.connect("start_fire", _on_start_fire)
	enemyDetector.connect("stop_fire", _on_stop_fire)
	enemyDetector.get_child(0).shape.radius = fire_range



func set_current_projectile(projectile_name: String):
	if projectiles_available.has(projectile_name):
		projectile_scene = projectiles_available[projectile_name]
	else:
		print("Projectile not found in available projectiles.")

func _process(delta: float):
	current_cooldown += delta
	if current_cooldown >= fire_rate and can_fire:
		current_cooldown = 0
		fire(enemyDetector.closest_enemy_position())

	
	

func fire(target_pos: Vector2):	
	var projectile_instance = projectile_scene.instantiate()
	var target_direction = (target_pos - projectile_spawn_point.global_position).normalized();
	self.rotation = target_direction.angle()
	projectile_instance.global_position = projectile_spawn_point.global_position
	projectile_instance.damage = damage
	projectile_instance.direction = target_direction
	projectile_instance.pierce = pierce
	projectile_instance.range_travel = fire_range
	projectile_instance.speed = projectile_speed
	projectile_instance.knockback_amount = knockback_amount
	projectile_instance.rotation  = target_direction.angle()
	get_tree().root.add_child(projectile_instance)
	
func _on_start_fire():
	can_fire = true
func _on_stop_fire():
	can_fire = false
