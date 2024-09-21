extends Control
## Main inventory controller. Propagates data to and creates individual inventory items.

var timer = 0
var speed = 1.5
var isOpening = false

var inventoryItem: PackedScene = load("res://Prefabs/inventory_item.tscn")
var inventoryItems = [[],[],[],[],[]]

var drawnItems = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func updateMonsters(playerMonsters):
	#$InventoryGrid
	# Resets inventory display to blank slate
	for cat in inventoryItems:
		for item in cat:
			if is_instance_valid(item): item.queue_free()
		
	inventoryItems = [[],[],[],[],[]]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# generic animatng code.
	if isOpening == true:
		timer += delta * speed
		if timer > 1: timer = 1
	else:
		timer -= delta * speed
		if timer < 0: timer = 0
	var processVal = 1
	#var processVal = sin(PI * timer / 2)
	anchor_top = -1 + (processVal)
	anchor_bottom = (processVal)
	pass

# Draws the current inventory tab.
func _on_inventory_tabs_tab_clicked(tab: int) -> void:
	# clears existing draws
	for node in $InventoryGrid.get_children():
		$InventoryGrid.remove_child(node)
	
	# does draws
	print(inventoryItems[tab])
	for item in inventoryItems[tab]:
		$InventoryGrid.add_child(item)
	pass # Replace with function body.
