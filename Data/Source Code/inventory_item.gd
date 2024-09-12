class_name InventoryItem
extends Resource
## Holds information related to an inventory item.

# tab category information.
enum CATEGORY {
	INGREDIENTS,
	BASIC_DRINKS,
	ADVANCED_DRINKS,
	RARITIES,
	KEY_ITEMS
}

# used to sort the inventory.
@export var index: float

@export var name: String
@export var sprite: Texture
@export var tab: CATEGORY

func _init(zInd = 0, p_name = "", p_sprite = null, p_tab = 0):
	index = zInd
	name = p_name
	sprite = p_sprite
	tab = p_tab
	
