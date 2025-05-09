# Main script for handling deck editor logic.
# Needs to be ported into the Overworld script. Will figure that out soon
# Click on cards (right) to add them into decks (left)

extends Control
@export var playerMons: Array[Monster]
@export var enemyMons: Array[Monster]
@export var cache: MonsterCache

var allCards: Array[Card]
var allMonsters: Array[Monster]
var storedID: int
var deckOpened: bool = true


var currentDeck = CardStorage.new()
var currentDeckZone = Zone.new()
var cardObject : PackedScene = load("res://Prefabs/card_object.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	cache.loadCards()
	
	allMonsters = cache.cache
	allCards = cache.cardCache
	
	playerMons = ConnectionManager.playerTeam
	while len(playerMons) < 3:
		playerMons.push_back(null)
	
	buildCards()
	buildMonsters()
	
	# sets up the buttons that let you choose monster slots
	var fullMons = playerMons + enemyMons
	for i in range(6):
		var temp = Button.new()
		if fullMons[i] == null:
			temp.text = "Monster" + str(i + 1)
		else:
			temp.text = fullMons[i].name
		# stores the monster's "id" as a meta variable, which then gets
		# retrieved by the onclick to be used later! clever
		temp.set_meta("id", i)
		temp.pressed.connect(_monster_button_pressed.bind(temp.get_meta("id")))
		%MonsterButtons.add_child(temp)
		
	
	# sets up a "change monster" button
	var temp = Button.new()
	temp.text = "change monster"
	temp.pressed.connect(toggleMonsters.bind())
	%MonsterButtons.add_child(temp)
	
	# sets up an extra button for each monster in Data/Monsters
	for monster in allMonsters:
		var tempContainer = HBoxContainer.new()
		var tempLabel = RichTextLabel.new()
		temp = TextureButton.new()
		temp.texture_normal = monster.sprite
		temp.ignore_texture_size = true
		temp.stretch_mode = TextureButton.STRETCH_SCALE
		temp.custom_minimum_size = Vector2(120, 120)
		temp.mouse_entered.connect(_enterTexButton.bind(temp))
		temp.mouse_exited.connect(_exitTexButton.bind(temp))
		temp.pressed.connect(_monster_select_pressed.bind(monster))
		
		tempLabel.text = monster.name + "\n" + str(monster.ALIGNMENT.keys()[monster.alignment]) + "\n" + str(monster.role)
		tempLabel.custom_minimum_size = Vector2(120, 120)
		
		tempContainer.add_theme_constant_override("separation", 20)
		tempContainer.add_child(temp)
		tempContainer.add_child(tempLabel)
		$MonsterSelectPanel/MonsterGridContainer.add_child(tempContainer)
		
	# sets up 2 buttons for importing/exporting teams
	temp = Button.new()
	temp.text = "export deck"
	temp.pressed.connect(exportMons.bind())
	%MonsterButtons.add_child(temp)
	
	temp = Button.new()
	temp.text = "import deck"
	temp.pressed.connect(importMons.bind())
	%MonsterButtons.add_child(temp)
	
	# return to title :3
	temp = Button.new()
	temp.text = "back to title"
	temp.pressed.connect(toTitle.bind())
	%MonsterButtons.add_child(temp)
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 

# finds every monster implemented so far and stores them to allMonsters for future
# stores Monster resources which we can plug diretly into teams (nice)
func buildMonsters():
	allMonsters = cache.cache
	pass

# finds every card made so far and stores them into allCards for future
# stores Card resources which plug directly into decks
func buildCards():
	cache.loadCards()
	allCards = cache.cardCache
	for card in allCards:
		print("added card: ", card.name)
		
# used to add cards to the cards display
# currently shows all cards (TODO: ADD FILTERING)
# it's the collection so you click here to add to the deck uhhh
func rebuildCards(alignment = "all", role = "all"): 
	for child in %RightGridContainer.get_children():
		child.queue_free() 
	for item in allCards:
		var temp: CardDisplay = cardObject.instantiate()
		var cParent = Control.new()
		var currentID = storedID
		var mon: Monster = null
		if currentID > 2:
			mon = enemyMons[currentID - 3]
		else:
			mon = playerMons[currentID]
		
		print("all card: ", item.name, ", ", item.get_script().get_path())
		print(item.role)
		print(mon.role)
		if mon != null && item.role not in ["Basic",mon.role,mon.name]:
			continue
			
		print(item.name)
		print(item.alignment)
		print(mon.alignment)
		if item.alignment not in [mon.alignment, item.ALIGNMENT.Default]:
			continue
			
		if mon != null && mon.name in [item.role]: #signature card
			temp.setTextColor(Color.YELLOW)
		elif mon != null && item.alignment in [mon.alignment, item.ALIGNMENT.Default]:
			temp.setTextColor(Color.from_string(Card.alignemColors[item.alignment], Color.WHITE))
		 
		temp.displayLocation = "collection"
		temp.setCard(item, 1, null, "collection")
		temp.deckEditController = self
		temp.set_meta("half", "right")
		temp.canDrag = false
		temp.clickable = true
		cParent.add_child(temp)
		%RightGridContainer.add_child(cParent)
		
# stupid function name
# loads the deck of a selected monster onto the left
func rebuildMonsters(id, setCards = true):
	var team
	if id > 2: 
		team = enemyMons
		id -= 3
	else:
		team = playerMons
	for child in %LeftGridContainer.get_children():
		child.queue_free() 
	if team[id] != null:
		if team[id].deck.storedCards.size() == 0:
			team[id].deck.storedCards = team[id].startingCardPool.storedCards
				
		# decks are stored as Deck Objects, which are good for decks but
		# bad for inventory management. we convert a deck to a CardStorage first
		# THEN we load the CardStorage
		currentDeck.convertDeck(team[id].deck)
		currentDeckZone.storedCards.clear()
		for ind in range(currentDeck.cardNames.size()):
			# loaded cardObjects get meta info that lets me add arbitrary
			# behaviour to them. hopefully i can modify the context tool to
			# do this for me but w/e
			var temp = cardObject.instantiate()
			var cParent = Control.new()
			var loadedCard = cache.getCard(cache.getCardIDByName(currentDeck.cardNames[ind]))
			
			for i in range(currentDeck.cardCounts[ind]):
				currentDeckZone.storedCards.append(loadedCard)
				
			temp.setCard(loadedCard, 1, null, "collection")
			temp.get_child(1).text = str(currentDeck.cardCounts[ind]) + "x"
			
			
			temp.displayLocation = "collection"
			temp.deckEditController = self
			temp.canDrag = false
			temp.clickable = true
			temp.set_meta("half", "left")
			cParent.add_child(temp)
			%LeftGridContainer.add_child(cParent)
	if setCards:
		rebuildCards()
	if playerMons != null && len(playerMons) > 0:
		ConnectionManager.setTeamManual(playerMons)

func toggleMonsters():
	$MonsterSelectPanel.visible = !$MonsterSelectPanel.visible

# selects a monster slot and loads their deck if possible so you can edit it
func _monster_button_pressed(id):
	var team
	var internalID
	if storedID > 2: 
		team = enemyMons
		internalID = storedID - 3
	else:
		team = playerMons 
		internalID = storedID
	if currentDeckZone.storedCards and team[internalID]:
		
		team[internalID].deck.storedCards = currentDeckZone.storedCards.duplicate()
	storedID = id
	rebuildMonsters(storedID)
	pass
	
# sets a monster into a selected monster slot
# ids 0-2 are player team, ids 3-5 are enemy team
func _monster_select_pressed(storedMonster):
	var team
	var internalID
	if storedID > 2: 
		team = enemyMons
		internalID = storedID - 3
	else:
		team = playerMons 
		internalID = storedID
	team[internalID] = storedMonster
	%MonsterButtons.get_child(storedID).text = storedMonster.name
	rebuildMonsters(storedID)
	$MonsterSelectPanel.visible = false
	pass

func moveCard(side, passCard):
	var team
	var internalID
	if storedID > 2: 
		team = enemyMons
		internalID = storedID - 3
	else:
		team = playerMons 
		internalID = storedID
		
	if side == "left":
		var temp: Array[Card] = [passCard]
		currentDeckZone.removeCards(temp)
		_monster_button_pressed(storedID)
		pass
	if side == "right":
		team[internalID].deck.storedCards.append(passCard)
		rebuildMonsters(storedID, false)
		pass
	pass


func _enterTexButton(button: TextureButton):
	button.modulate = Color(0.5,0.5,0.5,1)

func _exitTexButton(button: TextureButton):
	button.modulate = Color.WHITE

func exportMons():
	var tempDict: Dictionary[Monster, Array] = {}
	for mon in playerMons:
		tempDict[mon] = mon.deck.storedCards
	%PortText.text = cache.encode(cache.toCacheArray(tempDict))
	pass
	
func importMons():
	playerMons = cache.decode(%PortText.text)
	while len(playerMons) < 3:
		playerMons.push_back(null)
	rebuildMonsters(storedID)
	for num in len(playerMons):
		if playerMons[num] != null:
			%MonsterButtons.get_child(num).text = playerMons[num].name
		else:
			%MonsterButtons.get_child(num).text = "Monster" + str(num+1)
	pass

func toTitle():
	LoadManager.loadScene("Title")
