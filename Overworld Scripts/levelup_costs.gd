extends Panel
var timer = 0
var speed = 1.5
var isOpening = false

var storedItems = []
var inventoryItem: PackedScene = load("res://Prefabs/inventory_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initialize(monster):
	for item in storedItems:
			if is_instance_valid(item): item.queue_free()
	storedItems = []
	
	var itemArray = monster.LevelCosts[monster.levelingType][monster.level]
	var items = monster.levelingItems
	
	for i in range(itemArray.size()):
		var temp = inventoryItem.instantiate()
		temp.initiate(items[itemArray[i][1]], itemArray[i][0])
		storedItems.append(temp)
		$GridContainer.add_child(temp)

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
	anchor_top = 1.65 - (processVal)
	anchor_bottom = 1.98 - (processVal)
	pass
