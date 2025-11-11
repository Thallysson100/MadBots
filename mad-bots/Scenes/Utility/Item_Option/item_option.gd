extends TextureRect

@onready var lblName = $lbl_name
@onready var lblDescription = $lbl_description
@onready var lblrarity = $lbl_rarity
@onready var itemIcon = $TextureRect/itemIcon

var mouse_over = false
var item = null
@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade)

func _ready():
	connect("selected_upgrade",Callable(player,"upgrade_character"))
	lblName.text = ResourcesDb.UPGRADES[item]["displayname"]
	lblDescription.text = ResourcesDb.UPGRADES[item]["details"]
	update_lblrarity(ResourcesDb.UPGRADES[item]["rarity"])
	itemIcon.texture = load(ResourcesDb.UPGRADES[item]["icon"])

func _input(event):
	if event.is_action_pressed("click"):
		if mouse_over:
			emit_signal("selected_upgrade",item)

func _on_mouse_entered():
	mouse_over = true
	position.x += 10

func _on_mouse_exited():
	position.x -= 10
	mouse_over = false

func update_lblrarity(rarity: String):
	lblrarity.text = rarity.capitalize()

	match rarity.to_lower():
		"common":
			lblrarity.add_theme_color_override("font_color", Color("00bfff")) # azul
		"rare":
			lblrarity.add_theme_color_override("font_color", Color("00ff00")) # verde
		"epic":
			lblrarity.add_theme_color_override("font_color", Color("9400d3")) # roxo
		_:
			lblrarity.add_theme_color_override("font_color", Color("ffffff")) # branco padrão
