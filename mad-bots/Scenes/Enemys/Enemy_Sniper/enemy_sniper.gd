extends Enemy

@export var repel_radius: float = 100.0

func move(distance_to_player: float) -> void:
	if (distance_to_player <= repel_radius):
		velocity = -direction_to_player * speed
	move_and_slide()
