extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("death_screen")
	

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file(ResourcesDb.world_selected)


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Utility/MainMenu/MainMenu.tscn")
