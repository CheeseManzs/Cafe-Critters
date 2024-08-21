class_name BattleController
extends Node

#signal for gui choice
signal gui_choice

#monster object prefab
@export var monsterObject: PackedScene
@export var cardbuttonContiner: Node
@export var cardbuttonPrefab: PackedScene
#current turn, 0 is player, 1 is enemy
@export var currentTurn: int
#node that corrosponds to the player monster
var playerMonsterObj: MonsterDisplay
#node that corrosponds to the enemy monster
var enemyMonsterObj: MonsterDisplay

@export var debugTeamA: Array
@export var debugTeamB: Array

#UIs for active player monsters
@export var playerUI: Array[MonsterUI]
#UIs for active enemy monsters
@export var enemyUI: Array[MonsterUI]
#UI for choosing player actions
@export var playerChoiceUI: Control
#UI for shelfed mons
@export var shelfedMonUI: Array[ShelfUI]
#action buttons
@export var attackButton: Button
@export var defendButton: Button
var cardButtons: Array[Button] = []


#maximum number of monster than can be on the field per side at the same time
var maxActiveMons: int = 1
#battle monsters owned by the player
var playerTeam: Array[BattleMonster] = []
var playerObjs: Array[MonsterDisplay] = [] 
#index for current active player mon
var activePlayerMon: int = 0
#battle monsters owned by the enemy
var enemyTeam: Array[BattleMonster] = []
var enemyObjs: Array[MonsterDisplay] = [] 
#index for current active enemy mon
var activeEnemyMon: int = 0
#timer for waiting
var timer
#check if in turn
var inTurn: bool = false
#player's chosen (cached) action
var playerAction: Card
var playerCardID = -1
var playerSwitchID = -1
#enemy's chosen action
var enemyAction: Card

#set MP of player
var playerMP = 0
#set MP of enemy
var enemyMP = 0
#player passive MP gain
var playerMPGain = 3
#enemy passive MP gain
var enemyMPGain = 3
#player/enemy temporary passive MP gain
var playerMPTempGain = 0
var enemyMPTempGain = 0
#enemy ai object
var enemyAI: BattleAI
#add skipping
var skipChoice = false
# graveyard
var graveyard: Array[Card] = []
# banished cards
var banishedPlayerCards: Array[Card] = []
var banishedEnemyCards: Array[Card] = []
# list for future actions system
var futureActions: Array[FutureAction] = []
# list for conditional actions system
var conditionalActions: Array[ConditionalAction] = []

#instantiates a monster
func createMonster(isPlayer, monObj, tID) -> Node3D:
	#instantiate monster node from scene
	var newObj: Node3D = monsterObject.instantiate()
	#set the team id
	newObj.teamID = tID
	#set the raw data
	newObj.set_meta("Monster_Data",monObj)
	#set the player control bool
	newObj.set_meta("playerControlled", isPlayer)
	#add monster node to scene
	add_child(newObj)
	return newObj

func initialize(plrTeam: Array, enmTeam: Array) -> void:
	#create monsters on the player's side
	for index in len(plrTeam):
		#create battle monster object
		var newBattleMon = BattleMonster.new(plrTeam[index], self, true)
		
		shelfedMonUI[index].connectedMon = newBattleMon
		shelfedMonUI[index].reprocess()
		#add to player team
		playerTeam.push_back(newBattleMon)
	#set mp values
	playerMP = 0
	enemyMP = 0
	playerMPGain = 3
	enemyMPGain = 3
	
	
	#create monsters on the enemy's side
	for index in len(enmTeam):
		#create battle monster object
		var newBattleMon = BattleMonster.new(enmTeam[index], self, false)
		#add to enemy team
		enemyTeam.push_back(newBattleMon)
	
	
	
	for idIndex in len(playerTeam):
		#create battle object for player
		var mon: BattleMonster = playerTeam[activePlayerMon + idIndex]
		playerMonsterObj = createMonster(true, mon.rawData, idIndex)
		playerMonsterObj.position = playerMonsterObj.getMonsterPosition()
		playerMonsterObj.connectedMon = mon 
		playerObjs.push_back(playerMonsterObj)
		
		
	for idIndex in len(enemyTeam):	
		#create battle object for enemy
		var mon: BattleMonster = enemyTeam[activeEnemyMon + idIndex]
		enemyMonsterObj = createMonster(false, mon.rawData, idIndex)	
		enemyMonsterObj.position = enemyMonsterObj.getMonsterPosition()
		enemyMonsterObj.connectedMon = mon
		enemyObjs.push_back(enemyMonsterObj)
	
	#assign ui to player mon
	playerUI[0].setConnectedMon(getActivePlayerMon())
	#assign ui to enemy mon
	enemyUI[0].setConnectedMon(getActiveEnemyMon())
	#initialize AI
	enemyAI = BattleAI.new(self)
	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#debug initialization
	initialize(debugTeamA, debugTeamB)
	pass # Replace with function body.

# Check if a monster swap is valid
func validSwap(from: BattleMonster, to: BattleMonster) -> bool:
	var valid: bool = !to.hasStatus(Status.EFFECTS.KO) && (from != to)
	return valid

func addToGraveyard(card: Card):
	graveyard.push_back(card)
	#search for relevants statusses
	for mon in (playerTeam + enemyTeam):
		#decay
		if !mon.isKO() && mon.hasStatus(Status.EFFECTS.DECAY):
			var decayStatus = mon.getStatus(Status.EFFECTS.DECAY)
			mon.trueDamage(decayStatus.X)

func addArrayToGraveyard(cards: Array[Card]):
	for card in cards:
		addToGraveyard(card)

func chooseCards(count: int, requirement: Callable = func(x): return true ) -> Array[Card]:
	
	playerChoiceUI.show()
	setCardSelection(getActivePlayerMon(), true)
	for shelfUI in shelfedMonUI:
		shelfUI.switchButton.disabled = true
	var cardsChosen: Array[Card] = []
	while len(cardsChosen) < count && len(getActivePlayerMon().currentHand.storedCards) - len(cardsChosen) > 0:
		#check for chosen cards
		for uiIndex in len(getActivePlayerMon().currentHand.storedCards):
			var uiButton = cardButtons[uiIndex]
			var uiCard = getActivePlayerMon().currentHand.storedCards[uiIndex]
			print(uiCard.name,' ',uiIndex)
			if cardsChosen.has(uiCard):
				uiButton.setTextColor(Color.GOLD)
			else:
				uiButton.setTextColor(Color.WHITE)
			#check for special requirements
			if !requirement.call(uiCard):
				uiButton.disabled = true
			else:
				uiButton.disabled = false
			
		await gui_choice
		print('card ID:',playerCardID)
		var card = getActivePlayerMon().currentHand.storedCards[playerCardID]
		if !cardsChosen.has(card):
			cardsChosen.push_back(card)
		else:
			cardsChosen.remove_at(cardsChosen.find(card))
	for uiIndex in len(getActivePlayerMon().currentHand.storedCards):
			var uiButton = cardButtons[uiIndex]
			uiButton.setTextColor(Color.WHITE)
	return cardsChosen

func enemyChooseShelfedMon(count: int) -> Array[BattleMonster]:
	return enemyAI.enemyShelfed(count)
	

func chooseShelfedMon(count: int, playerControlled: bool = true) -> Array[BattleMonster]:
	print("Choosing mons!")
	if !playerControlled:
		return enemyChooseShelfedMon(count)
	
	playerChoiceUI.hide()
	setCardSelection(getActivePlayerMon(), true)
	
	for shelfUI in shelfedMonUI:
		if shelfUI.connectedMon.isKO():
			shelfUI.switchButton.disabled = true
		else:
			shelfUI.switchButton.disabled = false
			shelfUI.switchButton.text = "Select"
			shelfUI.setTextColor(Color.LIME_GREEN)
		
	var chosenMons: Array[BattleMonster] = []
	
	while len(chosenMons) < count && len(playerTeam) - len(chosenMons) - 1 > 0:
		playerCardID = -1
		#check for chosen cards
		for shelfUI in shelfedMonUI:
			if chosenMons.has(shelfUI.connectedMon):
				shelfUI.setTextColor(Color.GOLD)
			else:
				shelfUI.setTextColor(Color.LIME_GREEN)

		await gui_choice
		#ignore skips
		if playerCardID == -100:
			continue
		print('card ID:',playerCardID)
		var mon = playerTeam[playerSwitchID]
		if !chosenMons.has(mon):
			chosenMons.push_back(mon)
		else:
			chosenMons.remove_at(chosenMons.find(mon))
	
	for uiIndex in len(getActivePlayerMon().currentHand.storedCards):
			var uiButton = cardButtons[uiIndex]
			uiButton.setTextColor(Color.WHITE)
	
	#set shelf ui back to normal
	for shelfUI in shelfedMonUI:
		shelfUI.switchButton.disabled = true
		shelfUI.switchButton.text = "Switch"
		shelfUI.setTextColor(Color.WHITE)
	
	return chosenMons
		

func promptPlayerSwitch() -> void:
	BattleLog.singleton.log("Choose a switch-in!")
	playerChoiceUI.hide()
	for shelfUI in shelfedMonUI:
		shelfUI.switchButton.disabled = (shelfUI.connectedMon.hasStatus(Status.EFFECTS.KO))
	await gui_choice
	playerSwap(playerSwitchID)
	for shelfUI in shelfedMonUI:
			shelfUI.switchButton.disabled = true
	await get_tree().create_timer(1.0).timeout

func enemyDeclare() -> Array[BattleAction]:
	#initialize list of possible actions
	var actions: Array[BattleAction] = []
	#loop through active mons (currently only supports 1 active mon so it doesnt really matter)
	for i in maxActiveMons:
		var mon: BattleMonster = enemyTeam[activeEnemyMon + i]
		
		if !enemyAI.enemyShouldSwitch() && !mon.hasStatus(Status.EFFECTS.KO) && len(getActiveEnemyMon().playableCards()) > 0:
			#choose card if mon has not fainted
			if len(mon.playableCards()) == 0:
				BattleLog.singleton.log(mon.rawData.name + " has an empty hand!")
				continue
			#target is automatically set to the main active mon
			var chosenTargetID = -1
			var targSelf = false
			var chosenCard: Card = enemyAI.choiceEnemy(true)
			BattleLog.singleton.log(mon.rawData.name + " is going to use " + chosenCard.name)
			#add chosen card logic here
			
			#add to action queue
			var battleAction: BattleAction = BattleAction.new(
				mon,
				false,
				chosenCard.priority,
				chosenTargetID,
				targSelf,
				chosenCard,
				self
			)
			actions.push_back(battleAction)
		elif enemyMP > 0:
			var switchID: int = enemyAI.enemySwitch()
			if switchID == -1:
				continue
			var battleAction: BattleAction = BattleAction.new(
				mon,
				false,
				100,
				switchID,
				false,
				null,
				self,
				true
			)
			BattleLog.singleton.log(mon.rawData.name + " is going to swap to " + enemyTeam[switchID].rawData.name)
			actions.push_back(battleAction)
			#swap enemy
			pass
			
	return actions
	#await get_tree().create_timer(1.0).timeout

func getActivePlayerMon() -> BattleMonster:
	return playerTeam[activePlayerMon]

func getActiveEnemyMon() -> BattleMonster:
	return enemyTeam[activeEnemyMon]

#swaps active player mon to new mon at index newID
func playerSwap(newID) -> void:
	
	#get monster structs and objects
	var currentMon: BattleMonster = getActivePlayerMon()
	var newMon: BattleMonster = playerTeam[newID]
	var currentObj: MonsterDisplay = playerObjs[activePlayerMon]
	var newObj: MonsterDisplay = playerObjs[newID]
	
	if !validSwap(currentMon, newMon):
		return
	
	#swap team IDs
	var oldTID = currentObj.teamID
	currentObj.teamID = newObj.teamID
	newObj.teamID = oldTID
	
	playerUI[0].connectedMon = newMon
	playerUI[0].reloadUI()
	
	#setup new mon
	newMon.hardReset()
	
	activePlayerMon = newID
	
	#emit signal
	emitGUISignal()

#swaps active enemy mon to new mon at index newID
func enemySwap(newID) -> void:
	#get monster structs and objects
	var currentMon: BattleMonster = getActiveEnemyMon()
	var newMon: BattleMonster = enemyTeam[newID]
	var currentObj: MonsterDisplay = enemyObjs[activeEnemyMon]
	var newObj: MonsterDisplay = enemyObjs[newID]
	
	if !validSwap(currentMon, newMon):
		return
	
	#swap team IDs
	var oldTID = currentObj.teamID
	currentObj.teamID = newObj.teamID
	newObj.teamID = oldTID
	
	enemyUI[0].connectedMon = newMon
	enemyUI[0].reloadUI()
	
	#setup new mon
	newMon.hardReset()
	
	activeEnemyMon = newID
	
	#emit signal
	emitGUISignal()
	
#set card selection ui to specific mon
func setCardSelection(mon: BattleMonster, allSelectable = false):
	
	var container = cardbuttonContiner
	
	for button in cardbuttonContiner.get_children():
		if cardButtons.has(button):
			cardButtons.remove_at(cardButtons.find(button))
		button.queue_free()
	
	print("remaining: ",len(cardButtons))
	var id = 0
	
	print("adding ",len(mon.currentHand.storedCards), " buttons")
	for card in mon.currentHand.storedCards:
		var newButton: CardChoiceUI = cardbuttonPrefab.instantiate()
		newButton.choiceID = id
		newButton.controller = self
		newButton.show()
		container.add_child(newButton)
		cardButtons.push_back(newButton)
		id += 1
	
	print(len(cardButtons))
	for uiIndex in len(cardButtons):
		var cardButton: CardChoiceUI = cardButtons[uiIndex]
		if cardButton.choiceID >= len(mon.currentHand.storedCards):
			pass
			cardButton.hide()
		else:
			var card =  mon.currentHand.storedCards[cardButton.choiceID]
			cardButton.show()
			cardButton.text = card.name + " (" + str(card.cost) + " MP)"
			cardButton.tooltip_text = card.description
			if card.statusConditions.has(Status.EFFECTS.EMPOWER):
				cardButton.text += " (EMP)"
			cardButton.disabled = card.cost > playerMP || mon.hasStatus(Status.EFFECTS.KO)
			if allSelectable:
				cardButton.disabled = false

#banishes player cards to the graveyard
func banishPlayerCards(count: int):
	var cc = await chooseCards(count)
	getActivePlayerMon().currentHand.removeCards(cc)
	for c in cc:
		banishedPlayerCards.push_back(c)

#total cards the player has to use
func totalPlayableCards() -> Array[Card]:
	var cards: Array[Card] = []
	for mon in playerTeam:
		if !mon.isKO():
			cards += mon.playableCards()
	return cards

func enemyTotalPlayableCards() -> Array[Card]:
	var cards: Array[Card] = []
	for mon in enemyTeam:
		if !mon.isKO():
			cards += mon.playableCards()
	return cards

#banishes enemy cards to the graveyard
func banishEnemyCards(count: int):
	var cc = []
	for index in count:
		cc.push_back(getActiveEnemyMon().currentHand.storedCards[index])
	getActiveEnemyMon().currentHand.removeCards(cc)
	for c in cc:
		banishedEnemyCards.push_back(c)

func banishEnemyArray(cards: Array[Card]):
	banishArray(cards, false)

func banishArray(cards: Array[Card], isPlayer = true):
	for card in cards:
		if isPlayer:
			banishedPlayerCards.push_back(card)
		else:
			banishedPlayerCards.push_back(card)

func activeTurn() -> void:
	inTurn = true
	skipChoice = false
	playerMP += playerMPGain + playerMPTempGain
	enemyMP += enemyMPGain + enemyMPTempGain
	
	playerMPTempGain = 0
	enemyMPTempGain = 0
	
	if playerMP > 6:
		playerMP = 6
	if enemyMP > 6:
		enemyMP = 6
	
	
	#run future actions
	for futureAction in futureActions:
		#run future action (returns true if it activated this turn
		if await futureAction.processTurn():
			futureActions.remove_at(futureActions.find(futureAction))
	
	#run conditoinal actions
	for conditionalAction in conditionalActions:
		#run future action (returns true if it activated this turn
		if await conditionalAction.processTurn():
			conditionalActions.remove_at(conditionalActions.find(conditionalAction))
	
	#reset temporary values
	for mon in playerTeam + enemyTeam:
		if !mon.isKO():
			mon.reset()
	 
	
	
	#wait for enemy choice and animations
	if getActivePlayerMon().hasStatus(Status.EFFECTS.KO):
			await promptPlayerSwitch()
			inTurn = false
			return
		
	if getActiveEnemyMon().hasStatus(Status.EFFECTS.KO):
		enemySwap(enemyAI.enemySwitch())
		await get_tree().create_timer(1.0).timeout
		inTurn = false
		return
	
	var playerCanPlay = !(len(getActivePlayerMon().playableCards()) == 0 && playerMP == 0)
	var enemyCanPlay = !(len(getActiveEnemyMon().playableCards()) == 0 && enemyMP == 0)
	var endTurn = false
	
	while !getActivePlayerMon().isKO() && !getActiveEnemyMon().isKO() && (playerCanPlay || enemyCanPlay):
		
		playerCanPlay = !(len(getActivePlayerMon().playableCards()) == 0 && playerMP == 0)
		enemyCanPlay = !(len(getActiveEnemyMon().playableCards()) == 0 && enemyMP == 0)
		playerAction = null
		playerCardID = -1
		skipChoice = false
		
		#hide player gui
		playerChoiceUI.hide()
		var enemyActions = enemyDeclare()
	
		var actions: Array[BattleAction] = []
		
		print(getActiveEnemyMon().rawData.name)
		
		print(getActivePlayerMon().health, ',',getActivePlayerMon().hasStatus(Status.EFFECTS.KO))
		
		if endTurn:
			break
		
		for i in maxActiveMons:
			#show player gui
			
			playerChoiceUI.show()
			var mon: BattleMonster = playerTeam[activePlayerMon + i]
			
			setCardSelection(mon)
			
			for shelfUI in shelfedMonUI:
				shelfUI.switchButton.disabled = (shelfUI.connectedMon.hasStatus(Status.EFFECTS.KO)) || playerMP < 1
			#wait for a gui choice to be made
			if len(mon.playableCards()) <= 0 && playerMP == 0:
				continue
			await gui_choice
			for shelfUI in shelfedMonUI:
				shelfUI.switchButton.disabled = true
			playerChoiceUI.hide()
			
			#check for skipped turn
			if playerCardID == -100: 
				continue
			var battleAction: BattleAction
			if skipChoice:
				battleAction = BattleAction.new(
					mon,
					true,
					100,
					playerSwitchID,
					false,
					null,
					self,
					true
				)
			else:
				await get_tree().create_timer(0.01).timeout
				#run choices for player and enemy
				var chosenTargetID = -1
				var targSelf = false
				var chosenPriority = 0
				print(playerCardID)
				var chosenCard: Card = mon.currentHand.pullCard(playerCardID)
			
			#add to action queue
				battleAction = BattleAction.new(
					mon,
					true,
					chosenCard.priority,
					chosenTargetID,
					targSelf,
					chosenCard,
					self,
					false
				)
			actions.push_back(battleAction)
			
			#wait a bit for the next monster
			await get_tree().create_timer(0.3).timeout
		
		actions += enemyActions
		#if both sides skip, end turn
		if len(actions) == 0:
			BattleLog.singleton.log("Both sides skipped... ending turn")
			await get_tree().create_timer(0.3).timeout
			break
		var turnSequence = BattleSequence.new(actions)
		await turnSequence.runActions(self)
	inTurn = false

func skipTurn():
	playerCardID = -100
	emitGUISignal()

func emitGUISignal() -> void:
	gui_choice.emit()

func onHand(index: int) -> void:
	print("hand index ",index)
	playerCardID = index
	print("player card:",index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if no turn is started, start the next turn
	if !inTurn:
		activeTurn()
	pass
