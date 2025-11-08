extends Node



# Upgrade Database - A dictionary storing upgrade information
# Each upgrade has a name, description, associated functions to call, 
# arguments for the functions, rarity and the icon path
const UPGRADES = {
	#test item
	"Bomba": {
		"displayname": "Bomba",
		"details": "Te deixa bombado, calvo e broxa",
		"functions": ["add_gun",
					  "add_gun",
					  "add_gun",
					  "add_gun",
					  "add_gun",
					  "add_gun",
					  "update_guns",
					  "update_guns",
					  "update_guns",
					  "update_guns"],
		"arguments": [["gun_test"],
					  ["gun_test"],
					  ["gun_test"],
					  ["gun_test"],
					  ["gun_test"],
					  ["gun_test"],
					  ["fire_rate",10],
					  ["fire_range",10],
					  ["damage",0.1],
					  ["knockback_amount",400]],

		"rarity": "common",
		"icon": "res://Assets/Textures/Items/itens/1 Icons/Icon10_39.png"
	},
}
