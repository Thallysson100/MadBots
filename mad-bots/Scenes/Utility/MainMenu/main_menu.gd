extends Node2D

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options
@onready var level_selector: Panel = $LevelSelector


func _ready():
	main_buttons.visible = true
	options.visible = false
	level_selector.visible = false

func _on_start_pressed() -> void:
	main_buttons.visible = false
	level_selector.visible = true

func _on_options_pressed() -> void:
	main_buttons.visible = false
	options.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_options_pressed() -> void:
	main_buttons.visible = true
	options.visible = false


func _on_back_level_selector_pressed() -> void:
	main_buttons.visible = true
	level_selector.visible = false


func _on_level_1_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://World/world.tscn")

func _on_level_2_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://World/world.tscn")

func _on_level_3_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://World/world.tscn")
