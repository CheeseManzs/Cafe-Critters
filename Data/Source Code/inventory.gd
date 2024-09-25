class_name Inventory
extends Resource
## Helper class that provides helpful functions for inventory management.

var itemNames: Array = [[], [], [], [], []]
var itemData: Array = [[], [], [], [], []]

func _init():
	pass

func addItems(resourceString: String, quantity: int = 1):
	var refItem = load("res://Data/Items/" + resourceString + ".tres")
	var cat = refItem.tab
	var itemInd = itemNames[cat].find(resourceString)
	if itemInd == -1:
		itemNames[cat].push_back(resourceString)
		itemData[cat].push_back([refItem.index, quantity])
	else:
		itemData[cat][itemInd][1] += quantity
	
func removeItems(resourceString: String, quantity: int = 1):
	var refItem = load("res://Data/Items/" + resourceString + ".tres")
	var cat = refItem.tab
	var itemInd = itemNames[cat].find(resourceString)
	if itemInd == -1:
		return
	else:
		itemData[cat][itemInd][1] -= quantity
		if itemData[cat][itemInd][1] <= 0:
			itemData[cat].pop_at(itemInd)
			itemNames[cat].pop_at(itemInd)
