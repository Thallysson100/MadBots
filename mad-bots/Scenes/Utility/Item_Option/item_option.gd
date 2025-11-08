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
	if item == null:
		item = "Bomba"  # Default item for testing
	lblName.text = UpgradesDb.UPGRADES[item]["displayname"]
	lblDescription.text = UpgradesDb.UPGRADES[item]["details"]
	lblrarity.text = UpgradesDb.UPGRADES[item]["rarity"]
	itemIcon.texture = load(UpgradesDb.UPGRADES[item]["icon"])

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
