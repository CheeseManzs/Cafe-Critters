# Main script for handling deck editor logic.
# Needs to be ported into the Overworld script. Will figure that out soon
# Click on cards (right) to add them into decks (left)

extends Control
@export var playerMons: Array[Monster]
@export var enemyMons: Array[Monster]
@export var cache: MonsterCache
@export var searchBar: LineEdit
@export var sceneShiftingMode: bool = true

var allCards: Array[Card]
var allMonsters: Array[Monster]
var storedID: int = -1
var deckOpened: bool = true
var strictMode: bool = true


var currentDeck = CardStorage.new()
var currentDeckZone = Zone.new()
var cardObject : PackedScene = load("res://Prefabs/card_object.tscn")

# Called when the node enters the scene tree for the first time.

func initialize() -> void:
	if sceneShiftingMode:
		playerMons = ConnectionManager.playerTeam
	else:
		playerMons = OverworldPlayer.singleton.playerTeam.duplicate(true)
	buildCards()
	buildMonsters()
	for i in len(playerMons):
		if playerMons[i] != null:
			manageMonsterButton(i)
	
func _ready() -> void:
	
	cache.loadCards()
	
	allMonsters = cache.cache
	allCards = cache.cardCache
	
	if sceneShiftingMode:
		playerMons = ConnectionManager.playerTeam
	else:
		playerMons = OverworldPlayer.singleton.playerTeam.duplicate(true)
	
	for mon in playerMons:
		if mon.heldItem == null:
			mon.heldItem = HeldItem.NONE.duplicate()
	
	while len(playerMons) < 3:
		playerMons.push_back(null)
	
	buildCards()
	buildMonsters()
	
	# sets up the buttons that let you choose monster slots
	var fullMons = playerMons + enemyMons
	var iRange = 6
	if sceneShiftingMode == false:
		iRange = 3
		%MonsterButtons.columns = 3
	for i in range(iRange):
		var temp = Button.new()
		# stores the monster's "id" as a meta variable, which then gets
		# retrieved by the onclick to be used later! clever
		temp.set_meta("id", i)
		if i >= 3:
			temp.disabled = true
		temp.pressed.connect(_monster_button_pressed.bind(temp.get_meta("id")))
		%MonsterButtons.add_child(temp)
	
	manageMonsterButtons()
	
	# sets up a "change monster" button
	var temp = Button.new()
	temp.text = "Change Monster"
	temp.pressed.connect(toggleMonsters.bind())
	temp.disabled = true
	temp.name = "ChangeMonsterButton"
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
		
		tempLabel.text = monster.name + "\n" + str(Card.ALIGNMENT.keys()[monster.alignment]) \
		+ "\n" + str(monster.role) + "\n" + str(monster.passive.desc) + "\n" \
		+ str(monster.rawHealth * 4) + "/" + str(monster.rawAttack) + "/" \
		+ str(monster.rawDefense) + "/" + str(monster.rawSpeed)
		tempLabel.custom_minimum_size = Vector2(1200, 120)
		
		tempContainer.add_theme_constant_override("separation", 20)
		tempContainer.add_child(temp)
		tempContainer.add_child(tempLabel)
		$MonsterSelectPanel/ScrollContainer/MonsterGridContainer.add_child(tempContainer)
	
	# sets up 2 buttons for importing/exporting teams
	temp = Button.new()
	temp.text = "Export Deck"
	temp.pressed.connect(exportMons.bind())
	%MonsterButtons.add_child(temp)
	
	temp = Button.new()
	temp.text = "Import Deck"
	temp.pressed.connect(importMons.bind())
	%MonsterButtons.add_child(temp)
	
	# sets up button to empty a deck
	temp = Button.new()
	temp.text = "Clear Deck"
	temp.pressed.connect(clearDeck.bind())
	%MonsterButtons.add_child(temp)
	
	# return to title :3
	if sceneShiftingMode:
		temp = Button.new()
		temp.text = "Add Monster"
		temp.pressed.connect(addMon.bind())
		%MonsterButtons.add_child(temp)
		
		temp = Button.new()
		temp.text = "Remove Monster"
		temp.pressed.connect(removeMon.bind())
		%MonsterButtons.add_child(temp)
	
		temp = Button.new()
		temp.text = "Back to Title"
		temp.pressed.connect(toTitle.bind())
		%MonsterButtons.add_child(temp)
		
	# hooks up all the menuButton popups to signals
	%DrinkAlignment.get_popup().id_pressed.connect(setDrinkAlignment)
	%DrinkAlignment.get_popup().hide_on_checkable_item_selection = false
	%DrinkTier.get_popup().id_pressed.connect(setDrinkTier)
	%DrinkTier.get_popup().hide_on_checkable_item_selection = false
	%DrinkApply.button_down.connect(applyDrink)
	pass # Replace with function body.

func addMon():
	var addID = 0
	while addID < len(playerMons) and playerMons[addID] != null:
		addID += 1
	print("add id: ", addID)
	if addID > 2:
		return
	storedID = addID
	toggleMonsters()

func removeMon():
	if playerMons[storedID] == null:
		return
	playerMons[storedID] = null
	var currentID = storedID

	while currentID+1 <= len(playerMons)-1:
		playerMons[currentID] = playerMons[currentID+1]
		playerMons[currentID+1] = null
		currentID += 1
	
	while playerMons[storedID] == null and storedID > 0:
		storedID -= 1
	
	_monster_button_pressed(storedID)

func setDrinkDisplay(heldItem: HeldItem):
	%HPWeight.text = str(heldItem.statWeights[0])
	%ATKWeight.text = str(heldItem.statWeights[1])
	%DEFWeight.text = str(heldItem.statWeights[2])
	%SPDWeight.text = str(heldItem.statWeights[3])
	%ItemPassive.text = heldItem.passive.name
	for itemIndex in %DrinkAlignment.item_count:
		%DrinkAlignment.get_popup().set_item_checked(itemIndex, itemIndex in heldItem.alignments)
	for itemIndex in %DrinkTier.item_count:
		print("items: ", itemIndex, ", ", int(heldItem.tier))
		%DrinkTier.get_popup().set_item_checked(itemIndex, itemIndex == int(heldItem.tier))


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
		
		print("applying filter with ", searchBar.text)
		if applyFilter(item, mon, temp, false, searchBar.text):
			print("removing ", item.name)
			continue
		
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
func rebuildMonsters(id, setCards = true, setupMonster = false):
	var startingID = id
	var team
	if id > 2: 
		team = enemyMons
		id -= 3
	else:
		team = playerMons
	for child in %LeftGridContainer.get_children():
		child.queue_free() 
	
	if team[id] != null:
		if team[id].deck.storedCards.size() == 0 and setupMonster == true:
			team[id].deck.storedCards = team[id].startingCardPool.storedCards
				
		# decks are stored as Zones, which are good for decks but
		# bad for inventory management. we convert a deck to a CardStorage first
		# THEN we load the CardStorage
		currentDeck.convertDeck(team[id].deck)
		
		# currentDeckZone is used to store rendered cards
		currentDeckZone.storedCards.clear()
		
		for ind in range(currentDeck.cardNames.size()):
			# loaded cardObjects get meta info that lets me add arbitrary
			# behaviour to them. hopefully i can modify the context tool to
			# do this for me but w/e
			var temp = cardObject.instantiate()
			var cParent = Control.new()
			var loadedCard = cache.getCard(cache.getCardIDByName(currentDeck.cardNames[ind]))
			
			# cache.getCard() creates a new resource ID each time it's called
			# so storing multiple copies of the same card in currentDeckZone ensures
			# that they can be found later  
			for i in range(currentDeck.cardCounts[ind]):
				currentDeckZone.storedCards.append(loadedCard)
			
			
			# loadedCard is the card that gets rendered on screen
			temp.setCard(loadedCard, 1, null, "collection")
			if currentDeck.cardCounts[ind] > 3:
				temp.get_child(1).set("theme_override_colors/default_color",Color.RED)
			temp.get_child(1).text = str(currentDeck.cardCounts[ind]) + "x"
			applyFilter(loadedCard, team[id], temp, true, searchBar.text)
			temp.displayLocation = "collection"
			temp.deckEditController = self
			temp.canDrag = false
			temp.clickable = true
			temp.set_meta("half", "left")
			cParent.add_child(temp)
			%LeftGridContainer.add_child(cParent)
		
		# display level and stats of monster
		%LevelNumber.text = str(team[id].level)
		setLabels(team[id])
	if setCards:
		rebuildCards()
	if playerMons != null && len(playerMons) > 0:
		if sceneShiftingMode:
			ConnectionManager.setTeamManual(playerMons)
		else:
			OverworldPlayer.singleton.setTeam(playerMons)
	if team[id]:
		%HelperTitle.text = "Currently Editing: " + team[id].name + " (" + str(currentDeckZone.storedCards.size()) + "/40)"
	else:
		%HelperTitle.text = "Slot " + str(startingID + 1)
		for child in %RightGridContainer.get_children():
			child.queue_free() 
	
	
	manageMonsterButtons()
	
	if playerMons[storedID] == null:
		return
	setDrinkDisplay(playerMons[storedID].getHeldItem())
	
	

func toggleMonsters():
	$MonsterSelectPanel.visible = !$MonsterSelectPanel.visible
	print("vis: ", $MonsterSelectPanel.visible)

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
	
	# only runs when going from one deck to another
	# currentDeckZone is the "live" version of the current deck
	# so it needs to be copies into the monster's real deck, as a "save" operation
	if internalID >= 0 && internalID < len(team) and id == storedID and team[internalID]:
		team[internalID].deck.storedCards = currentDeckZone.storedCards.duplicate()
	
	if id < len(team) && team[id]:
		storedID = id
		
	if storedID < len(playerMons):
		rebuildMonsters(storedID)
	
	if storedID < 0 || storedID >= len(team) || team[storedID] == null:
		return
	print("item owner: ", team[storedID].name)
	setDrinkDisplay(team[storedID].heldItem)
	
	if sceneShiftingMode:
		%MonsterButtons.get_node("ChangeMonsterButton").disabled = false
	
	
	
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
	rebuildMonsters(storedID, true, true)
	setLabels(team[internalID])
	$MonsterSelectPanel.visible = false
	pass

# called whenever a card is clicked
# side is left in the monster deck and right in the master list
func moveCard(side, passCard):
	var team
	var internalID
	if storedID > 2: 
		team = enemyMons
		internalID = storedID - 3
	else:
		team = playerMons 
		internalID = storedID
		
	
	setLabels(team[internalID])
	
	if side == "left":
		# removes a card from the monster's deck
		# currentDeckZone holds copies of display card which is why this works
		var temp: Array[Card] = [passCard]
		await currentDeckZone.removeCards(temp)
		_monster_button_pressed(storedID)
		pass
	if side == "right":
		# needs some kind of validation first
		if currentDeck.getCard(passCard.name) < 3 or strictMode == false:
			team[internalID].deck.storedCards.append(passCard)
			rebuildMonsters(storedID, false)
		pass
	pass

# applies visual changes to target card based on monster
# returns true if the card would get filtered out
func applyFilter(item: Card, mon, crd, loose = false, searchText: String = ""):
	
	print("searching with ", searchText)
	#activate search
	if len(searchText) > 0:
		if !CardSearch.search(searchText, item):
			return true

	
	if mon != null && item.role not in ["Basic",mon.role,mon.name]:
		if strictMode and !loose:
			return true
		else:
			crd.setTextColor(Color.RED)
	
	if mon != null:
		var allAlignments = [mon.alignment, item.ALIGNMENT.Default]+mon.getHeldItem().alignments
		if mon != null and item.alignment not in allAlignments:
			if strictMode and !loose:
				return true
			else:
				crd.setTextColor(Color.RED)
		
	if mon != null && mon.name in [item.role]: #signature card
		crd.setTextColor(Color.YELLOW)
	crd.setFaceColor(Color.from_string(Card.alignemColors[item.alignment], Color.WHITE))
	crd.get_node("Front/Role").text = item.role[0]
pass

func _enterTexButton(button: TextureButton):
	button.modulate = Color(0.5,0.5,0.5,1)

func _exitTexButton(button: TextureButton):
	button.modulate = Color.WHITE

func exportMons():
	var tempDict: Dictionary[Monster, Array] = {}
	for mon in playerMons:
		if mon:
			tempDict[mon] = mon.deck.storedCards
	%PortText.text = cache.encode(cache.toCacheArray(tempDict))
	pass

func manageMonsterButton(num):
	var button: Button = %MonsterButtons.get_child(num)
	if playerMons[num] != null:
		button.text = playerMons[num].name
		button.icon = playerMons[num].sprite
		button.expand_icon = false
		button.add_theme_constant_override("icon_max_width", 32)
		button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	else:
		button.text = "Monster" + str(num+1)
		button.icon = null

func manageMonsterButtons():
	for num in len(playerMons):
		manageMonsterButton(num)

func importMons():
	playerMons = cache.decode(%PortText.text)
	while len(playerMons) < 3:
		playerMons.push_back(null)
	rebuildMonsters(storedID)
	manageMonsterButtons()
	pass

func clearDeck():
	if []:
		print("yeah")
	else:
		print("nah")
	currentDeckZone.storedCards.clear()
	_monster_button_pressed(storedID)
	pass

func toTitle():
	LoadManager.loadScene("Title")

func setLabels(mon: Monster):
	mon.level = int(%LevelNumber.text)
	var boost = mon.heldItem.getBoost(mon)
	%StatsLabel.text = str(int(mon.getHealth() + boost[0])) + " HP, " + \
	str(int(mon.getAttack() + boost[1])) + " ATK, \n" + \
	str(int(mon.getDefense() + boost[2])) + " DEF, " + \
	str(int(mon.getSpeed() + boost[3])) + " SPD"

func toggleStrict(toggled_on: bool) -> void:
	strictMode = !strictMode
	rebuildMonsters(storedID)
	pass # Replace with function body.


func _on_card_search_bar_text_submitted(new_text: String) -> void:
	searchBar.text = new_text
	print("triggered for ", new_text)
	rebuildCards() # Replace with function body.
	return


func toggleDrinkMenu() -> void:
	%DrinkPanel.visible = !%DrinkPanel.visible
	pass # Replace with function body.

func setDrinkAlignment(id: int) -> void:
	var team
	var internalID
	if storedID > 2: 
		team = enemyMons
		internalID = storedID - 3
	else:
		team = playerMons 
		internalID = storedID
	if !team[internalID].heldItem:
		team[internalID].heldItem = HeldItem.new()
		pass # do a thing that creates a held item for the monster lol!
	%DrinkAlignment.get_popup().toggle_item_checked(id)
	if team[internalID].heldItem.alignments.find(id) >= 0:
		team[internalID].heldItem.alignments.erase(id)
	else:
		team[internalID].heldItem.alignments.append(id)
	pass

func applyDrink() -> void:
	var team
	var internalID
	if storedID > 2: 
		team = enemyMons
		internalID = storedID - 3
	else:
		team = playerMons 
		internalID = storedID
	if !team[internalID].heldItem:
		team[internalID].heldItem = HeldItem.new()
		pass # do a thing that creates a held item for the monster lol!
	var setHI: HeldItem = team[internalID].heldItem
	setHI.statWeights = [
		float(%HPWeight.text),
		float(%ATKWeight.text),
		float(%DEFWeight.text),
		float(%SPDWeight.text)
	]
	setHI.passive = cache.getPassiveByName(%ItemPassive.text)
	print("drink string: ", setHI.toString())
	print("decoded: ", setHI.fromString(setHI.toString(), cache).toString())
	rebuildMonsters(storedID)

func setDrinkTier(id: int) -> void:
	var team
	var internalID
	if storedID > 2: 
		team = enemyMons
		internalID = storedID - 3
	else:
		team = playerMons 
		internalID = storedID
	if !team[internalID].heldItem:
		team[internalID].heldItem = HeldItem.new()
		pass # do a thing that creates a held item for the monster lol!
	for i in range(5):
		%DrinkTier.get_popup().set_item_checked(i, false)
	%DrinkTier.get_popup().toggle_item_checked(id)
	team[internalID].heldItem.tier = id


func _on_level_number_text_submitted(new_text: String) -> void:
	var team
	var internalID
	if storedID > 2: 
		team = enemyMons
		internalID = storedID - 3
	else:
		team = playerMons 
		internalID = storedID
	setLabels(team[internalID])
	pass # Replace with function body.
