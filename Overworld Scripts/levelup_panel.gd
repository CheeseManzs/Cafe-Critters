extends Panel
var timer = 0
var speed = 1.5
var isOpening = false
var cardObject : PackedScene = load("res://Prefabs/card_object.tscn")
var storedCards = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initialize(monster):
	$RichTextLabel.text = "HP: " + str(monster.getHealth()) + " → " + str(monster.getHealth(monster.level + 1))\
			+ "\nATK: " + str(monster.getAttack()) + " → " + str(monster.getAttack(monster.level + 1))\
			+ "\nDEF: " + str(monster.getDefense()) + " → " + str(monster.getDefense(monster.level + 1))\
			+ "\nNew Cards:"
	
	# card positioning rules:
	# x is equal to panel x divided by 3
	# y is equal to 180, with 360px seperations between each card
	var index = 0
	for card in storedCards:
			if is_instance_valid(card): card.queue_free()
	storedCards = []
	# gonna go on a whaling trip lemme know if you need anything
	for card in monster.levelupCards[monster.level].storedCards:
		var temp = cardObject.instantiate()
		temp.displayLocation = "collection"
		temp.setCard(card, 1, null, "collection")
		storedCards.append(temp)
		$ScrollContainer/Panel.add_child(temp)
		var xlen = ($ScrollContainer/Panel.size.x) / 3
		temp.position = Vector2(xlen * (1 + (index % 2)) - 360, (180 + 360 * floor(index / 2)) - 400)
		
		index += 1
		
	# nightmare dimension
	#for item in storedItems:
			#if is_instance_valid(item): item.queue_free()
	#storedItems = []
	#
	#var itemArray = monster.LevelCosts[monster.levelingType][monster.level]
	#var items = monster.levelingItems
	#
	#for i in range(itemArray.size()):
		#var temp = inventoryItem.instantiate()
		#temp.initiate(items[itemArray[i][1]], itemArray[i][0])
		#storedItems.append(temp)
		#$GridContainer.add_child(temp)

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
	anchor_top = -0.95 + ((processVal))
	anchor_bottom = -0.05 + ((processVal))
	pass
