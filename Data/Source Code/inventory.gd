class_name Inventory
extends Resource
## Helper class that provides helpful functions for inventory management.

@export var items: Dictionary


func _init():
	pass

func addItems(resourceString: String, quantity: int = 1):
	items.get_or_add(resourceString, 0)
	items[resourceString] += quantity
	
func removeItems(resourceString: String, quantity: int = 1):
	items.get_or_add(resourceString, 0)
	items[resourceString] -= quantity
	if items[resourceString] <= 0:
		items.erase(resourceString)
