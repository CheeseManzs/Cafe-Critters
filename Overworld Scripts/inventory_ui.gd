extends Control
## Main inventory controller. Propagates data to and creates individual inventory items.

var timer = 0
var speed = 1.5
var isOpening = false

var inventoryItem: PackedScene = load("res://Prefabs/inventory_item.tscn")
var inventoryItems = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func updateItems(playerInventory: Inventory):
	$InventoryGrid
	var locItems = playerInventory.items
	for item in locItems:
		print(item)
		var temp = inventoryItem.instantiate()
		temp.initiate(item, locItems[item])
		inventoryItems.append(inventoryItem.instantiate())
		$InventoryGrid.add_child(temp)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isOpening == true:
		timer += delta * speed
		if timer > 1: timer = 1
	else:
		timer -= delta * speed
		if timer < 0: timer = 0
	
	var processVal = sin(PI * timer / 2)
	anchor_top = -1 + (processVal)
	anchor_bottom = (processVal)
	pass
