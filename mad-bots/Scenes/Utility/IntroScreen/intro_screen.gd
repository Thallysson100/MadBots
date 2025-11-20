extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("TitleFade")
	await animation_player.animation_finished
	animation_player.play("TextFade")
