extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	animation_player.play("death_screen")
	

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://World/world.tscn")


func _on_quit_pressed() -> void:
	animation_player.play("try_again")
	get_tree().change_scene_to_file("res://Scenes/Utility/MainMenu/MainMenu.tscn")
