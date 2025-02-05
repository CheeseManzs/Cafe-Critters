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
	buildCards()
	buildMonsters()
	for i in range(6):
		var temp = Button.new()
		temp.text = "monster" + str(i + 1)
		temp.set_meta("id", i)
		temp.pressed.connect(_monster_button_pressed.bind(temp.get_meta("id")))
		$ScrollContainer/Control/Panel.add_child(temp)
	var id = 0
	for monster in allMonsters:
		var temp = Button.new()
		temp.text = monster.name
		temp.pressed.connect(_monster_select_pressed.bind(id))
		id += 1
		$Panel/MonsterGridContainer.add_child(temp)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 

func buildMonsters():
	var monsterDir = DirAccess.open("res://Data/Monsters")
	monsterDir.list_dir_begin()
	var readMonsterName = monsterDir.get_next()
	while readMonsterName != "":
		allMonsters.push_back(load("res://Data/Monsters/" + readMonsterName))
		readMonsterName = monsterDir.get_next()
	pass

func buildCards():
	var cardDir = DirAccess.open("res://Data/Cards")
	cardDir.list_dir_begin()
	var readCardName = cardDir.get_next()
	while readCardName != "":
		allCards.push_back(load("res://Data/Cards/" + readCardName))
		readCardName = cardDir.get_next()
		
func rebuildCards(): 
	for item in allCards:
		var temp = cardObject.instantiate()
		var cParent = Control.new()
		temp.displayLocation = "collection"
		temp.setCard(item, 1, null, "collection")
		temp.deckEditController = self
		temp.set_meta("half", "right")
		cParent.add_child(temp)
		%RightGridContainer.add_child(cParent)
		
func rebuildMonsters(id):
	var team
	if id > 2: 
		team = enemyMons
		id -= 3
	else:
		team = playerMons 
	for item in team[id].deck:
		var temp = cardObject.instantiate()
		var cParent = Control.new()
		temp.displayLocation = "collection"
		temp.setCard(item, 1, null, "collection")
		temp.deckEditController = self
		temp.set_meta("half", "left")
		cParent.add_child(temp)
		%LeftGridContainer.add_child(cParent)
		pass
		
	#for i in range(storedCards.itemNames.size()):
	#	for j in range(storedCards.itemNames[i].size()):
	#		# does the copy operation.
	#		# first creates the display node and loads its properties.
	#		var temp = storedCards.instantiate()
	#		temp.initiate(storedCards.cardNames[i][j], storedCards.cardData[i][j][1])

func _monster_button_pressed(id):
	pass
	
func _monster_select_pressed(id):
	pass
