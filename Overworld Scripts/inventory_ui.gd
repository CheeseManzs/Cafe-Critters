extends Control
## Main inventory controller. Propagates data to and creates individual inventory items.

var timer = 0
var speed = 1.5
var isOpening = false

var inventoryItem: PackedScene = load("res://Prefabs/inventory_item.tscn")
var inventoryItems = [[],[],[],[],[]]
var currentTab = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# copies the player's inventory into inventoryItems, which are the physical ui nodes
func updateItems(playerInventory: Inventory, startTab):
	
	# Resets inventory display to blank slate
	for cat in inventoryItems:
		for item in cat:
			if is_instance_valid(item): item.queue_free()
		
	inventoryItems = [[],[],[],[],[]]
	
	# copies the player inventory to inventoryItems
	# the player inventory is data, but inventoryItems is nodes. important.
	for i in range(playerInventory.itemNames.size()):
		for j in range(playerInventory.itemNames[i].size()):
			# does the copy operation.
			# first creates the display node and loads its properties.
			var temp = inventoryItem.instantiate()
			temp.initiate(playerInventory.itemNames[i][j], playerInventory.itemData[i][j][1])
			# then stores it into inventoryItems.
			inventoryItems[i].append(temp)
			# initially only loads the first tab, but can load others just in case ;)
			_on_inventory_tabs_tab_clicked(startTab)
		

func sortItems(playerInventory: Inventory, targetTab: int):
	# i miss matlab sometimes
	# packs both itemNames and itemData into a signle array
	# this is to preserve index order
	var packedArray = []
	for i in range(playerInventory.itemNames[targetTab].size()):
		packedArray[i] = playerInventory.itemData[targetTab][i]
		packedArray[i].append(playerInventory.itemNames[targetTab][i])
	
	# [index, quantity, name], sorts by ascending index
	packedArray.sort_custom(func(a, b): return a[0] < b[0])
	
	# clears out player inventory tab (passed by reference) and preps it for recreation
	playerInventory.itemNames[targetTab] = []
	playerInventory.itemData[targetTab] = []
	
	# unpacks the packed array and puts everything back into place
	for i in range(packedArray.size()):
		playerInventory.itemData[targetTab][i] = [packedArray[i][0], packedArray[i][1]]
		playerInventory.itemNames[targetTab][i] = packedArray[i][2]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# generic animatng code.
	if isOpening == true:
		timer += delta * speed
		if timer > 1: timer = 1
	else:
		timer -= delta * speed
		if timer < 0: timer = 0
	#var processVal = 1
	var processVal = sin(PI * timer / 2)
	anchor_top = -1 + (processVal)
	anchor_bottom = (processVal)
	pass

# Draws the current inventory tab.
func _on_inventory_tabs_tab_clicked(tab: int) -> void:
	currentTab = tab
	# clears existing draws
	for node in $InventoryGrid.get_children():
		$InventoryGrid.remove_child(node)
	
	# does draws
	print(inventoryItems[tab])
	for item in inventoryItems[tab]:
		$InventoryGrid.add_child(item)
	pass # Replace with function body.
