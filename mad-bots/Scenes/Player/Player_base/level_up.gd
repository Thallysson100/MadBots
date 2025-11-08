extends TextureRect

@onready var lvlUpSound = get_node("%snd_levelup")  # Reference to the level-up sound effect
@onready var upgradeOptions = get_node("%UpgradeOptions")  # Reference to the upgrade options container
@onready var itemOptions = preload("res://Scenes/Utility/Item_Option/item_option.tscn")  # Preload the item option scene

var levelPanel_position = Vector2.ZERO  # Store the original position of the level-up panel
var levelup_queue = []  # Queue to manage level-up panel requests

func show_levelup_panel():

	levelup_queue.append(true)  # Add a request to the queue

	if levelup_queue.size() == 1:
		process_levelup_queue()

func process_levelup_queue():
	if levelup_queue.size() > 0:
		show_levelup_panel_instance()
	else:
		get_tree().paused = false


func show_levelup_panel_instance():
	lvlUpSound.play()
	levelPanel_position = self.position
	var screen_center = get_viewport_rect().size / 2  # Get the center of the screen
	var panel_center = self.get_size() / 2  # Get the center of the panel
	# Calculate the target position for centering the panel
	var target_position = screen_center - panel_center * self.get_scale()  
	var tween = self.create_tween()
	tween.tween_property(self, "position", target_position, 0.2).set_trans(Tween.TransitionType.TRANS_QUINT).set_ease(Tween.EaseType.EASE_IN)

	var options = 0
	while options < 3:
		var item_option_instance = itemOptions.instantiate()
		# If upgradeOptions is a container (e.g., VBoxContainer), let it handle sizing
		item_option_instance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		item_option_instance.size_flags_vertical = Control.SIZE_EXPAND_FILL
		upgradeOptions.add_child(item_option_instance)
		options += 1

	get_tree().paused = true

func hide_levelup_panel():
	var options_children = upgradeOptions.get_children()
	for child in options_children:
		child.queue_free()
	self.position = levelPanel_position
	
	if levelup_queue.size() > 0:
		levelup_queue.pop_front()  # Remove the processed request
		process_levelup_queue()
