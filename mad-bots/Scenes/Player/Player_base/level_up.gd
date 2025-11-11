extends TextureRect

@onready var lvlUpSound = get_node("%snd_levelup")  # Reference to the level-up sound effect
@onready var upgradeOptions = get_node("%UpgradeOptions")  # Reference to the upgrade options container
@onready var itemOption = preload("res://Scenes/Utility/Item_Option/item_option.tscn")  # Preload the item option scene
@onready var expBar = get_node("%ExperienceBar")  # Reference to the experience bar GUI element


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

	var i = 0
	var upgrades = get_random_upgrades(expBar.experience_level, 3)
	while i < 3:
		var item_option_instance = itemOption.instantiate()
		item_option_instance.item = upgrades[i]
		# If upgradeOptions is a container (e.g., VBoxContainer), let it handle sizing
		item_option_instance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		item_option_instance.size_flags_vertical = Control.SIZE_EXPAND_FILL
		upgradeOptions.add_child(item_option_instance)
		i += 1

	get_tree().paused = true

func hide_levelup_panel():
	var options_children = upgradeOptions.get_children()
	for child in options_children:
		child.queue_free()
	self.position = levelPanel_position
	
	if levelup_queue.size() > 0:
		levelup_queue.pop_front()  # Remove the processed request
		process_levelup_queue()

# Optional: Get multiple unique random upgrades (for choice selection)
func get_random_upgrades(experience_level: int, count: int) -> Array:
	var selected = []
	var attempts = 0
	var max_attempts = count * 1000  # Prevent infinite loop
	
	while selected.size() < count and attempts < max_attempts:
		var upgrade = get_random_upgrade(experience_level)
		if upgrade != "" and not selected.has(upgrade):
			selected.append(upgrade)
		attempts += 1
	
	return selected

# Main function: Get a random upgrade based on experience level
func get_random_upgrade(experience_level: int) -> String:
	var selected_rarity = select_random_rarity(experience_level)
	var available_upgrades = get_upgrades_by_rarity(selected_rarity)
	
	if available_upgrades.is_empty():
		# Fallback to common if no upgrades of selected rarity
		available_upgrades = get_upgrades_by_rarity("common")
		if available_upgrades.is_empty():
			push_error("No upgrades available!")
			return ""
	return available_upgrades[randi() % available_upgrades.size()]

# Select a random rarity based on experience level
func select_random_rarity(experience_level: int) -> String:
	var weights = calculate_rarity_weights(experience_level)
	var roll = randf() * 100.0
	var cumulative = 0.0
	
	for rarity in ResourcesDb.RARITY_CURVES.keys():
		cumulative += weights[rarity]
		if roll <= cumulative:
			return rarity
	
	return "common"  # Fallback

func get_upgrades_by_rarity(rarity: String) -> Array:
	var filtered = []
	for upgrade_key in ResourcesDb.UPGRADES.keys():
		if ResourcesDb.UPGRADES[upgrade_key]["rarity"] == rarity:
			filtered.append(upgrade_key)
	return filtered

# Calculate rarity weights based on experience level
func calculate_rarity_weights(experience_level: int) -> Dictionary:
	var weights = {}
	var total_weight = 0.0
	
	for rarity in ResourcesDb.RARITY_CURVES.keys():
		var curve = ResourcesDb.RARITY_CURVES[rarity]
		# Weight = base + (level * modifier), clamped to minimum 1
		var weight = max(1.0, curve["base_weight"] + (experience_level * curve["level_modifier"]))
		weights[rarity] = weight
		total_weight += weight
	
	# Normalize to percentages
	for rarity in weights.keys():
		weights[rarity] = (weights[rarity] / total_weight) * 100.0
	
	return weights

# Debug function to see current probabilities
func print_rarity_chances(experience_level: int):
	var weights = calculate_rarity_weights(experience_level)
	print("Level %d rarity chances:" % experience_level)
	for rarity in weights.keys():
		print("  %s: %.1f%%" % [rarity, weights[rarity]])
