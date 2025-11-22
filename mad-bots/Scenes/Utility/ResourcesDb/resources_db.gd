extends Node

var world_selected: String = ""


const PACKEDSCENES = {
	"Guns": {
		"Futuristic Chicago": preload("res://Scenes/Player/Guns/futuristic_chicago.tscn"), # Corrected file path
		"Rocket Launcher": preload("res://Scenes/Player/Guns/rocket_launcher.tscn"), # Corrected file path
	},
	"Projectiles": {
		"projectile_test": preload("res://Scenes/Projectile/projectile_test.tscn"), # Corrected file path
		"projectile_test_for_enemy": preload("res://Scenes/Projectile/projectile_for_enemy1.tscn"), # Corrected file path
		"projectile_bomb": preload("res://Scenes/Projectile/Projectile_bomb/projectile_bomb.tscn"), # Corrected file path
	}
}
# Rarity weight curves to influence upgrade selection based on player level
const RARITY_CURVES = {
	"common": {
		"color": "00bfff", #blue
		"base_weight": 100.0,
		"level_modifier": -10  # Decreases as level increases
	},
	"rare": {
		"color": "00ff00", #green
		"base_weight": 0.0,
		"level_modifier": 5  # Increases slightly with level
	},
	"epic": {
		"color": "9400d3", #purple
		"base_weight": 0.0,
		"level_modifier": 5  # Increases with level
	}
}

const DEFAULT_UPGRADE = "Heal_health"
# Each upgrade has a name, description, associated functions to call, 
# arguments for the functions, rarity and the icon path
const UPGRADES = {
	# 🔵 Common
	"Agile_Body": {
		"displayname": "Agile Body",
		"details": "Movement speed: [color=#00ff00]+15%[/color]. Max health: [color=#ff0000]-10[/color] points.",
		"rarity": "common",
		"icon": "res://Assets/Textures/GUI/icons/1 Icons/10/Skillicon10_29.png",
		"functions": ["update_player_velocity", "update_max_health"],
		"arguments": [[0.15], [-10]],
	},

	"Heavy_Armor": {
		"displayname": "Heavy Armor",
		"details": "Max health: [color=#00ff00]+25[/color]. Movement speed: [color=#ff0000]-10%[/color].",
		"rarity": "common",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/Icon10_14.png",
		"functions": ["update_max_health", "update_player_velocity"],
		"arguments": [[25], [-0.10]],
	},

	"Sharpened_Ammo": {
		"displayname": "Sharpened Ammo",
		"details": "Bullet damage: [color=#00ff00]+10%[/color]. Fire rate: [color=#ff0000]-10%[/color].",
		"rarity": "common",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/Icon10_28.png",
		"functions": ["update_guns", "update_guns"],
		"arguments": [["damage", 0.10], ["fire_rate", -0.10]],
	},
	"Heal_health": {
		"displayname": "Health Pack",
		"details": "Heals the player by [color=#00ff00]+10[/color] health points.",
		"rarity": "common",
		"icon": "res://Assets/Textures/GUI/icons/1 Icons/6/Skillicon6_16.png",
		"functions": ["heal_player"],
		"arguments": [[10]],
	},

	# 🟢 Rare
	"Overclocked_Guns": {
		"displayname": "Overclocked Guns",
		"details": "Fire rate: [color=#00ff00]+20%[/color]. Projectile speed: [color=#ff0000]-15%[/color].",
		"rarity": "rare",
		"icon": "res://Assets/Textures/GUI/icons/1 Icons/1/Skillicon1_17.png",
		"functions": ["update_guns", "update_guns"],
		"arguments": [["fire_rate", 0.20], ["projectile_speed", -0.15]],
	},

	"Reinforced_Bullets": {
		"displayname": "Reinforced Bullets",
		"details": "Damage: [color=#00ff00]+25%[/color]. Knockback: [color=#ff0000]-20%[/color].",
		"rarity": "rare",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/Icon10_18.png",
		"functions": ["update_guns", "update_guns"],
		"arguments": [["damage", 0.25], ["knockback_amount", -0.20]],
	},

	"Cool_Classes": {
		"displayname": "Cool Classes",
		"details": "Projectile range: [color=#00ff00]+30%[/color]. Fire rate: [color=#ff0000]-15%[/color].",
		"rarity": "rare",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/Icon10_08.png",
		"functions": ["update_guns", "update_guns"],
		"arguments": [["fire_range", 0.30], ["fire_rate", -0.15]],
	},

	# 🟣 Epic
	"Pierce": {
		"displayname": "Pierce",
		"details": "Pierce: [color=#00ff00]+2[/color]. Projectile speed: [color=#ff0000]-20%[/color].",
		"rarity": "epic",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/cow_nose_ring.png",
		"functions": ["update_guns", "update_guns"],
		"arguments": [["pierce", 2], ["projectile_speed", -0.20]],
	},

	"Glass_Cannon": {
		"displayname": "Glass Cannon",
		"details": "Damage: [color=#00ff00]+40%[/color]. Max health: [color=#ff0000]-30[/color] points.",
		"rarity": "epic",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/glass_cannon-removebg-preview.png",
		"functions": ["update_guns", "update_max_health"],
		"arguments": [["damage", 0.40], [-30]],
	},

	"Steroid": {
		"displayname": "Steroid",
		"details": "Max health: [color=#00ff00]+50[/color]. Knockback: [color=#00ff00]+30%[/color]. Movement speed: [color=#ff0000]-20%[/color].",
		"rarity": "epic",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/Icon10_39.png",
		"functions": ["update_max_health", "update_guns", "update_player_velocity"],
		"arguments": [[50], ["knockback_amount", 0.30], [-0.20]],
	},
	"Futuristic Chicago": {
		"displayname": "Futuristic Chicago",
		"details": "Adds Futuristic Chicago gun in your arsenal.",
		"rarity": "epic",
		"icon": "res://Assets/Textures/Armas_E_Personagens/1 Icons/Icon29_01.png",
		"functions": ["add_gun"],
		"arguments": [["Futuristic Chicago"]],
	},
	"Rocket Launcher": {
		"displayname": "Rocket Launcher",
		"details": "Adds Rocket Launcher gun in your arsenal.",
		"rarity": "epic",
		"icon": "res://Assets/Textures/Armas_E_Personagens/1 Icons/Icon29_39.png",
		"functions": ["add_gun"],
		"arguments": [["Rocket Launcher"]],
	},
}
