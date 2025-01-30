extends Control
@export var storedCards: CardStorage = CardStorage.new()
@export var monDeck: CardStorage = CardStorage.new()
@export var playerMons: Array[Monster]
@export var enemyMons: Array[Monster]
var allCards: Array[Card]
var allMonsters: Array[Monster]

var cardObject : PackedScene = load("res://Prefabs/card_object.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rebuildCards()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 

func rebuildMonsters():
	var monsterDir = DirAccess.open("res://Data/Cards")
	monsterDir.list_dir_begin()
	var readMonsterName = monsterDir.get_next()
	while readMonsterName != "":
		allCards.push_back(load("res://Data/Monsters/" + readMonsterName))
		readMonsterName = monsterDir.get_next()
	pass

func rebuildCards(): 
	var cardDir = DirAccess.open("res://Data/Cards")
	cardDir.list_dir_begin()
	var readCardName = cardDir.get_next()
	while readCardName != "":
		allCards.push_back(load("res://Data/Cards/" + readCardName))
		readCardName = cardDir.get_next()
		
	for item in allCards:
		var temp = cardObject.instantiate()
		var cParent = Control.new()
		temp.displayLocation = "collection"
		temp.setCard(item, 1, null, "collection")
		cParent.add_child(temp)
		$CardGridHSplit/RightScrollContainer/RightGridContainer.add_child(cParent)
		
	#for i in range(storedCards.itemNames.size()):
	#	for j in range(storedCards.itemNames[i].size()):
	#		# does the copy operation.
	#		# first creates the display node and loads its properties.
	#		var temp = storedCards.instantiate()
	#		temp.initiate(storedCards.cardNames[i][j], storedCards.cardData[i][j][1])
