class_name InventoryItem
extends Resource
## Holds information related to an inventory item.

# tab category information.
# used to tell the inventory ui which tab to sort the item in.
enum CATEGORY {
	INGREDIENTS,
	BASIC_DRINKS,
	ADVANCED_DRINKS,
	RARITIES,
	KEY_ITEMS
}

enum ALIGNMENT {
	Default,
	Mise,
	Rea,
	Anvi,
	Sec,
	Eco,
	Jacks,
	Blanc,
	Kress
}

# used to sort the inventory.
@export var index: float

@export var name: String
@export var sprite: Texture
@export var tab: CATEGORY
@export var desc: String
@export var rarity: int
@export var god: ALIGNMENT

func _init(zInd = 0, p_name = "", p_sprite = null, p_tab = 0, p_desc = "", p_rar = 0):
	index = zInd
	name = p_name
	sprite = p_sprite
	tab = p_tab
	desc = p_desc
	rarity = p_rar
	
