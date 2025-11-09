extends Node

# Upgrade Database - A dictionary storing upgrade information
const RARITY_CURVES = {
	"common": {
		"base_weight": 100.0,
		"level_modifier": -1.5  # Decreases as level increases
	},
	"rare": {
		"base_weight": 	0.0,
		"level_modifier": 1  # Increases slightly with level
	},
	"epic": {
		"base_weight": 0.0,
		"level_modifier": 0.5  # Increases with level
	}
}
# Each upgrade has a name, description, associated functions to call, 
# arguments for the functions, rarity and the icon path
const UPGRADES = {
	# 🔵 Common
	"Agile_Body": {
		"displayname": "Agile Body",
		"details": "Increases movement speed by +15%, but reduces max health by 10 points.",
		"rarity": "common",
		"icon": "res://Assets/Textures/GUI/icons/1 Icons/10/Skillicon10_29.png",
		"functions": ["update_player_velocity", "update_max_health"],
		"arguments": [[0.15], [-10]],
	},

	"Heavy_Armor": {
		"displayname": "Heavy Armor",
		"details": "Increases max health by +25, but reduces movement speed by 10%.",
		"rarity": "common",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/Icon10_14.png",
		"functions": ["update_max_health", "update_player_velocity"],
		"arguments": [[25], [-0.10]],
	},

	"Sharpened_Ammo": {
		"displayname": "Sharpened Ammo",
		"details": "Increases bullet damage by +10%, but reduces fire rate by 10%.",
		"rarity": "common",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/Icon10_28.png",
		"functions": ["update_guns", "update_guns"],
		"arguments": [["damage", 0.10], ["fire_rate", -0.10]],
	},

	# 🟢 Rare
	"Overclocked_Guns": {
		"displayname": "Overclocked Guns",
		"details": "Increases fire rate by +20%, but reduces projectile speed by 15%.",
		"rarity": "rare",
		"icon": "res://Assets/Textures/image_placeholder.png",
		"functions": ["update_guns", "update_guns"],
		"arguments": [["fire_rate", 0.20], ["projectile_speed", -0.15]],
	},

	"Reinforced_Bullets": {
		"displayname": "Reinforced Bullets",
		"details": "Increases damage by +25%, but reduces knockback by 20%.",
		"rarity": "rare",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/Icon10_18.png",
		"functions": ["update_guns", "update_guns"],
		"arguments": [["damage", 0.25], ["knockback_amount", -0.20]],
	},

	"Cool_Classes": {
		"displayname": "Cool Classes",
		"details": "Increases projectile range by +30%, but reduces fire rate by 15%.",
		"rarity": "rare",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/Icon10_08.png",
		"functions": ["update_guns", "update_guns"],
		"arguments": [["fire_range", 0.30], ["fire_rate", -0.15]],
	},

	# 🟣 Epic
	"Piercing_Core": {
		"displayname": "Piercing Core",
		"details": "Increases pierce by +2, but reduces projectile speed by 20%.",
		"rarity": "epic",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/Icon10_29.png",
		"functions": ["update_guns", "update_guns"],
		"arguments": [["pierce", 2], ["projectile_speed", -0.20]],
	},

	"Glass_Cannon": {
		"displayname": "Glass Cannon",
		"details": "Increases damage by +40%, but reduces max health by 30 points.",
		"rarity": "epic",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/glass_cannon-removebg-preview.png",
		"functions": ["update_guns", "update_max_health"],
		"arguments": [["damage", 0.40], [-30]],
	},

	"Juggernaut": {
		"displayname": "Juggernaut",
		"details": "Increases max health by +50 and knockback by +30%, but reduces movement speed by 20%.",
		"rarity": "epic",
		"icon": "res://Assets/Textures/image_placeholder.png",
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
}
