class_name BattleController
extends Node

#signal for gui choice
signal gui_choice
signal synced 


#multiplayer global variables
var multiplayer_enemyChose = false
var multiplayer_enemyActions: Array[BattleAction]
var multiplayer_playerHand: Array[Card] = []
var multiplayer_enemyHand: Array[Card] = []
var multiplayer_choice_buffer: Array[int] = []
var rng_sync = false
var multiplayer_loaded_peer = false
#monster object prefab
static var multiplayer_game = false
static var multiplayer_seed = 0
static var global_rng = RandomNumberGenerator.new()
@export var monsterCache: MonsterCache
@export var dashParticles: GPUParticles3D
@export var monsterObject: PackedScene
@export var cardbuttonPrefab: PackedScene
@export var detailsPanel: DetailsPanel
@export var impactEffect: PackedScene
var showingDetails = false
#current turn, 0 is player, 1 is enemy
@export var currentTurn: int
#node that corrosponds to the player monster
var playerMonsterObj: MonsterDisplay
#node that corrosponds to the enemy monster
var enemyMonsterObj: MonsterDisplay


static var playerBattleTeam: Array[Monster]
static var enemyBattleTeam: Array[Monster]
static var enemyPersonality: AIPersonality

#UIs for active player monsters
@export var playerUI: Array[MonsterUI]
#UIs for active enemy monsters
@export var enemyUI: Array[MonsterUI]
#UI for shelfed mons
@export var shelfedMonUI: Array[ShelfUI]
#action buttons
@export var skipButton: Button
@export var cardPrefab: PackedScene
@export var deckController: DeckController

var cardButtons: Array[CardDisplay] = []
var enemyCards: Array[CardDisplay] = []


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
#cache winning player
var winner: int = 0
#display card used for animations
var shownCard: CardDisplay
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

func getTeam(monster: BattleMonster) -> Array[BattleMonster]:
	if monster.playerControlled:
		return playerTeam
	else:
		return enemyTeam

func initialize(plrTeam: Array, enmTeam: Array) -> void:
	
	#set mp values
	playerMP = 0
	enemyMP = 0
	playerMPGain = 3
	enemyMPGain = 3
	
	
	#create monsters on the enemy's side
	var creationOrder = [[plrTeam, playerTeam, true], [enmTeam, enemyTeam, false]]
	if !ConnectionManager.host:
		creationOrder.reverse()
	
	#create monsters on the player's side
	for orderList in creationOrder:
		var team = orderList[0]
		var plrControl = orderList[2]
		var teamSend = orderList[1]
		for index in len(team):
			#create battle monster object
			var newBattleMon = BattleMonster.new(team[index], self, plrControl)
			newBattleMon.gameID = index
			if !plrControl && ConnectionManager.host:
				newBattleMon.gameID += 3
			if plrControl && !ConnectionManager.host:
				newBattleMon.gameID += 3
			#newBattleMon.reset()
			if plrControl:
				shelfedMonUI[index].connectedMon = newBattleMon
				shelfedMonUI[index].reprocess()
			#add to corrosponding team
			teamSend.push_back(newBattleMon)
	
	
	
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

	enemyAI = BattleAI.new(self, enemyPersonality)
	
	#reset every mon
	basicReset(true)
	
func basicReset(skipKOCheck = false, resetActiveMons = false):
	var resetOrder = [playerTeam,enemyTeam]
	#sync rng order
	if multiplayer_game && !ConnectionManager.host:
		resetOrder = [enemyTeam, playerTeam]
	
	for team in resetOrder:
		for mon in team:
			if (skipKOCheck || !mon.isKO()) && (resetActiveMons || (mon != getActivePlayerMon() && mon != getActiveEnemyMon())):
				await mon.reset()

func createImpact(pos):
	var impactNode: GameVFX = impactEffect.instantiate()
	add_child(impactNode)
	impactNode.global_position = pos
	impactNode.particleEmitter.emitting = true

func playerUsableMonCount():
	var count = len(playerTeam)
	for mon in playerTeam:
		if !mon.isKO():
			count -= 1
	return count

#check for player loss
func playerLost():
	for mon in playerTeam:
		if !mon.isKO():
			return false
	return true

func enemyLost():
	for mon in enemyTeam:
		if !mon.isKO():
			return false
	return true	

func getNextChoice():
	while len(multiplayer_choice_buffer) <= 0:
		await get_tree().process_frame
	var multi_choice = multiplayer_choice_buffer[0]
	multiplayer_choice_buffer.remove_at(0)
	return multi_choice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("reading personality: ",enemyPersonality.aggression)
	#debug initialization
	global_rng = RandomNumberGenerator.new()
	if multiplayer_game:
		var idCache = monsterCache.toCacheArray(playerBattleTeam)
		rpc("set_enemy_team", JSON.stringify(idCache))
		await synced
		if ConnectionManager.host:
			print("seed setter:",multiplayer.get_unique_id())
			print("seed sending:",global_rng.seed)
			rpc("sync_rng", global_rng.seed, global_rng.state)
			global_rng.seed = global_rng.seed
		while !rng_sync:
			await get_tree().process_frame 
	print("rng_seed:"+str(global_rng.seed))
	initialize(playerBattleTeam, enemyBattleTeam)
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

func parseBattleAction(mon: BattleMonster, actionID, switchID, switchAction = false, p_playerControlled = true) -> BattleAction:
	if actionID == -100: 
		return null
	var battleAction: BattleAction
	if !switchAction:
		await get_tree().create_timer(0.01).timeout
		#run choices for player and enemy
		var chosenTargetID = -1
		var targSelf = false
		var chosenPriority = 0
		
		var chosenCard: Card = mon.currentHand.pullCard(actionID)
		print(mon.rawData.name, ": pulling ",chosenCard.name," at index ", actionID)
	
	#add to action queue
		battleAction = BattleAction.new(
			mon,
			p_playerControlled,
			chosenCard.priority,
			chosenTargetID,
			targSelf,
			chosenCard,
			self,
			false
		)
	else:
		battleAction = BattleAction.new(
			mon,
			p_playerControlled,
			100,
			switchID,
			false,
			null,
			self,
			true
		)
	return battleAction

## Called when the player gains control of the game.
func playerChooseCards(count: int, endable = false, requirement: Callable = func(x): return true ) -> Array[Card]:
	## Draws the appropriate cards of their current mon.
	setCardSelection(getActivePlayerMon(), true)
	if endable:
		skipButton.text = "Done"
		skipButton.disabled = false
	
	for shelfUI in shelfedMonUI:
		shelfUI.switchButton.disabled = true
		
	
	var cardsChosen: Array[Card] = []

	while len(cardsChosen) < count && len(getActivePlayerMon().currentHand.storedCards) - len(cardsChosen) > 0:
		#check for chosen cards
		for uiIndex in len(getActivePlayerMon().currentHand.storedCards):
			var uiButton = cardButtons[uiIndex]
			var uiCard = getActivePlayerMon().currentHand.storedCards[uiIndex]
			if cardsChosen.has(uiCard):
				uiButton.setTextColor(Color.GOLD)
			else:
				uiButton.setTextColor(Color.WHITE)
			#check for special requirements
			if !requirement.call(uiCard):
				uiButton.isDisabled = true
			else:
				uiButton.isDisabled = false
			
			
		await gui_choice
		if endable && playerCardID == -100:
			break
		var card = getActivePlayerMon().currentHand.storedCards[playerCardID]
		if !cardsChosen.has(card):
			cardsChosen.push_back(card)
		else:
			cardsChosen.remove_at(cardsChosen.find(card))
	for uiIndex in len(getActivePlayerMon().currentHand.storedCards):
			var uiButton = cardButtons[uiIndex]
			uiButton.setTextColor(Color.WHITE)
		
	if endable:
		skipButton.text = "Skip"
		skipButton.disabled = true	
	
	return cardsChosen


func enemyChooseCards(count: int, requirement: Callable = func(x): return true ) -> Array[Card]:
	var cardsChosen: Array[Card] = []
	cardsChosen = enemyAI.enemyChooseHand(count, requirement)
	return cardsChosen
	


func chooseCards(count: int, playerControlled: bool = true, endable = false, requirement: Callable = func(x): return true ) -> Array[Card]:
	var cardsChosen: Array[Card] = []
	if playerControlled:
		cardsChosen = await playerChooseCards(count, endable, requirement)
	else:
		cardsChosen = await enemyChooseCards(count, requirement)
	return cardsChosen

func forceRngSync():
	rng_sync = false
	var timer = 3000
	if ConnectionManager.host:
		rpc("sync_rng", global_rng.seed, global_rng.state)
	while !rng_sync && timer > 0:
		timer -= 1
		await get_tree().process_frame 

#return enemy
func enemyChooseShelfedMon(count: int) -> Array[BattleMonster]:
	return enemyAI.enemyShelfed(count)

#returns active opposing mon
func getOpposingMon(playerControlled: bool) -> BattleMonster:
	if playerControlled:
		return getActiveEnemyMon()
	else:
		return getActivePlayerMon()

func hidePlayerChoiceUI(removeAll = false):
	for cardButton in cardButtons:
		if cardButton.choiceID != playerCardID || removeAll:
			cardButton.hideCard()
		else:
			shownCard = cardButton
			cardButton.selected = true
			cardButton.raise()

func randomBool() -> bool:
	print("randomness from ",self.multiplayer.get_unique_id())
	var boolArr = [true, false]
	if BattleController.multiplayer_game && !ConnectionManager.host:
		boolArr.reverse()
	return boolArr[BattleController.global_rng.randi_range(0,1)]

func getHigherSpeed(a: BattleMonster, b: BattleMonster):
	if a.speed > b.speed:
		return true
	if a.speed < b.speed:
		return false
	else:
		print("higher speed is random! > ",self.multiplayer.get_unique_id())
		return randomBool()

func getLowerID(a: BattleMonster, b: BattleMonster):
	if a.gameID > b.gameID:
		return true
	if a.gameID < b.gameID:
		return false
	else:
		print("lower id is random! > ",multiplayer.get_unique_id())
		return randomBool()
		

func sortedActiveMonList() -> Array:
	var monArr = [getActivePlayerMon(),getActiveEnemyMon()]
	if ConnectionManager.host:
		monArr.reverse()
	monArr.sort_custom(getLowerID)
	return monArr
	
func sortedMonList() -> Array:
	var monArr = playerTeam+enemyTeam
	if ConnectionManager.host:
		monArr = enemyTeam+playerTeam
	monArr.sort_custom(getLowerID)
	return monArr

func chooseShelfedMon(count: int, playerControlled: bool = true) -> Array[BattleMonster]:
	if !playerControlled && !multiplayer_game:
			return enemyChooseShelfedMon(count)
	
	hidePlayerChoiceUI()
	setCardSelection(getActivePlayerMon(), true)
	if playerControlled:
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
		
		var chosenMonID = 0
		if playerControlled:
			await gui_choice
			chosenMonID = playerCardID
		elif multiplayer_game:
			chosenMonID = await getNextChoice()
		#ignore skips
		if chosenMonID == -100:
			continue
		var mon: BattleMonster = null
		if playerControlled:
			mon = playerTeam[chosenMonID]
		elif multiplayer_game:
			mon = enemyTeam[chosenMonID]
		
		if !chosenMons.has(mon):
			chosenMons.push_back(mon)
		else:
			chosenMons.remove_at(chosenMons.find(mon))
	
	if playerControlled:
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
	hidePlayerChoiceUI(true)
	skipButton.disabled = true
	for shelfUI in shelfedMonUI:
		if shelfUI.connectedMon != null:
			shelfUI.switchButton.disabled = (shelfUI.connectedMon.hasStatus(Status.EFFECTS.KO))
	await gui_choice
	rpc("send_choice",playerSwitchID)
	await playerSwap(playerSwitchID)
	for shelfUI in shelfedMonUI:
			shelfUI.switchButton.disabled = true
	await get_tree().create_timer(1.0).timeout

func promptEnemySwitch() -> void:
	var enmSwapChoice: int
	if multiplayer_game:
		enmSwapChoice = await getNextChoice()
	else:
		enmSwapChoice = enemyAI.enemySwitch()
	await enemySwap(enmSwapChoice)
	await get_tree().create_timer(1.0).timeout

func enemyDeclare(canSwitch = false) -> Array[BattleAction]:
	#initialize list of possible actions
	var actions: Array[BattleAction] = []
	
	#loop through active mons (currently only supports 1 active mon so it doesnt really matter)
	for i in maxActiveMons:
		var trySwitch = false
		var mon: BattleMonster = enemyTeam[activeEnemyMon + i]
		
		if !(enemyAI.enemyShouldSwitch() || mon.hasStatus(Status.EFFECTS.KO)) && len(getActiveEnemyMon().playableCards()) > 0:
			#choose card if mon has not fainted
			if len(mon.playableCards()) == 0:
				BattleLog.singleton.log(mon.rawData.name + " has an empty hand!")
				continue
			#target is automatically set to the main active mon
			var chosenTargetID = -1
			var targSelf = false
			var chosenCard: Card = enemyAI.choiceEnemy(true)
			
			
			if chosenCard == null && canSwitch:
				trySwitch = true
			elif chosenCard == null:
				continue
			
			if !trySwitch:
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
		elif enemyMP > 0 && canSwitch && enemyAI.enemyShouldSwitch():
			trySwitch = false
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
			actions.push_back(battleAction)
			#swap enemy
			pass
		
		if trySwitch && enemyMP > 0:
			pass
			var switchID: int = enemyAI.enemyPossibleSwitch()
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
			actions.push_back(battleAction)
		
	
	return actions
	#await get_tree().create_timer(1.0).timeout

func getActivePlayerMon() -> BattleMonster:
	return playerTeam[activePlayerMon]

func getActiveEnemyMon() -> BattleMonster:
	return enemyTeam[activeEnemyMon]

func universalSwap(oldMon, newMon):
	var container: VBoxContainer
	if oldMon.playerControlled:
		container = playerUI[0].externalGaugeContainer
	else:
		container = enemyUI[0].externalGaugeContainer 
	while container.get_child_count() > 0:
		container.get_child(0).free()
	await newMon.getPassive().customUI(newMon, self)

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
	await newMon.hardReset()
	await currentMon.carryStatusConditions(newMon)
	
	await universalSwap(currentMon, newMon)
	
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
	await newMon.hardReset()
	
	activeEnemyMon = newID
	await universalSwap(currentMon, newMon)
	#emit signal
	emitGUISignal()
	
#set card selection ui to specific mon

func displayEnemyCards(mon: BattleMonster):
	for cardDis in enemyCards:
		if cardDis != null:
			cardDis.queue_free()
	
	var index = 0
	for card in mon.currentHand.storedCards:
		
		var newCardDis: CardDisplay = cardPrefab.instantiate()
		get_parent().add_child(newCardDis)
		newCardDis.scaleFactor = 0.75
		
		enemyCards.append(newCardDis)
		newCardDis.fromSide = true
		newCardDis.straight = true
		newCardDis.show()
		newCardDis.canPress = false
		newCardDis.setCard(card,index,self)
		
		index += 1

func setCardSelection(mon: BattleMonster, allSelectable = false):
	
	## Removes all existing Card UI elements. -A
	while len(cardButtons) > 0:
		for button in cardButtons:
			cardButtons.remove_at(cardButtons.find(button))
			button.queue_free()
	
	var id = 0

	## Creates a new Card UI element for each card in the current monster's hand.
	## Assigns each card ui element a corresponding ID.
	for card in mon.currentHand.storedCards:
		var newButton: CardDisplay = cardPrefab.instantiate()
		get_parent().add_child(newButton)
		
		newButton.setCard(card, id, self)
		newButton.show()
		
		cardButtons.push_back(newButton)
		id += 1
	
	## Modifies card text wherever necessary.
	for uiIndex in len(cardButtons):
		var cardButton: CardDisplay = cardButtons[uiIndex]
		if cardButton.choiceID >= len(mon.currentHand.storedCards):
			## Hides cards if there's more cards ui elements than cards in hand. -A (?????)
			pass
			cardButton.hideCard()
		else:
			var card =  mon.currentHand.storedCards[cardButton.choiceID]
			#cardButton.show()
			#cardButton.text = card.name + " (" + str(card.cost) + " MP)"
			#cardButton.tooltip_text = card.description
			if card.statusConditions.has(Status.EFFECTS.EMPOWER):
				#cardButton.text += " (EMP)"
				pass
			## Disables the card if you can't affortd it.
			var disableCard = card.cost > playerMP || mon.hasStatus(Status.EFFECTS.KO) || mon.hasStatus(Status.EFFECTS.CANT_PLAY)
			if disableCard && !allSelectable:
				cardButton.isDisabled = true

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



## seems to be the main gameplay loop? looks like it's what calls everything else
## running this starts a new turn, and does everything associated with it -a
func activeTurn() -> void:
	inTurn = true
	#manage dead turns before anything else
	var preEnd = false
	for mon in sortedActiveMonList():
		if mon.isKO():
			if !mon.playerControlled:
				await promptEnemySwitch()
			else:
				await promptPlayerSwitch()
			preEnd = true
	
	if preEnd:
		inTurn = false
		return
	
	currentTurn += 1
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
	
	hidePlayerChoiceUI(true)
	
	#check abilities
	#post reset actions

	for mon in sortedMonList():
		await mon.getPassive().initPassive(mon,self)
	
	
	#reset temporary values
	basicReset(false,true)
	
	
	
	
	
	
	var playerCanPlay = !(len(getActivePlayerMon().playableCards()) == 0 && playerMP == 0)
	var enemyCanPlay = !(len(getActiveEnemyMon().playableCards()) == 0 && enemyMP == 0)
	var endTurn = false
	
	await getActivePlayerMon().getPassive().onTurnStart(getActivePlayerMon(), self)
	var firstSubTurn = true
	while !getActivePlayerMon().isKO() && !getActiveEnemyMon().isKO() && (playerCanPlay || enemyCanPlay):
		
		if !firstSubTurn:
			await getActivePlayerMon().getPassive().onSubTurnStart(getActivePlayerMon(), self)
			await getActiveEnemyMon().getPassive().onSubTurnStart(getActiveEnemyMon(), self)
		
		createDeckDisplay()	
		playerCanPlay = !(len(getActivePlayerMon().playableCards()) == 0 && playerMP == 0)
		enemyCanPlay = !(len(getActiveEnemyMon().playableCards()) == 0 && enemyMP == 0)
		playerAction = null
		playerCardID = -1
		skipChoice = false
		
		#hide player gui
		#hidePlayerChoiceUI()
		for cardButton in cardButtons:
			cardButton.hideCard()
		
		displayEnemyCards(getActiveEnemyMon())
		var enemyActions = []
		if !multiplayer_game:
			enemyActions = enemyDeclare(true)
		
		var actions: Array[BattleAction] = []
		
		if endTurn:
			print("ending turn!")
			break
		
		for sorted_mon in sortedActiveMonList():
			await sorted_mon.getPassive().onSubTurnEnd(sorted_mon, self)
		
		firstSubTurn = false
			
		

		#show player gui
		var mon: BattleMonster = getActivePlayerMon()
		
		
		setCardSelection(mon)
		
		#wait for a gui choice to be made
		var skipChoosingPhase = false
		if len(mon.playableCards()) <= 0 && (playerMP == 0 || playerUsableMonCount() <= 1):
			skipChoosingPhase = true
		skipButton.disabled = false
		for shelfUI in shelfedMonUI:
			if shelfUI.connectedMon == null:
				shelfUI.switchButton.disabled = true
				continue
			shelfUI.switchButton.disabled = (shelfUI.connectedMon.hasStatus(Status.EFFECTS.KO)) || playerMP < 1
		if !skipChoosingPhase:
			await gui_choice
			rpc("set_enemy_choice",playerCardID,playerSwitchID,skipChoice)
			
			skipButton.disabled = true
			toggleDetails()
			for shelfUI in shelfedMonUI:
				shelfUI.switchButton.disabled = true
			hidePlayerChoiceUI()
			
			
			var battleAction: BattleAction = await parseBattleAction(mon, playerCardID, playerSwitchID, skipChoice)
			
			#check for skipped turn
			if battleAction != null:
				actions.push_back(battleAction)
		else:
			skipButton.disabled = true
			await hidePlayerChoiceUI(true)
			await get_tree().create_timer(1.0).timeout
			rpc("set_enemy_choice",-100,-100,true)
		
		if multiplayer_game:
			BattleLog.singleton.log("Waiting for opponent...")
			while !multiplayer_enemyChose:
				await get_tree().process_frame
			enemyActions = multiplayer_enemyActions
			multiplayer_enemyChose = false
		
		actions += enemyActions
		#if both sides skip, end turn
		if len(enemyActions) == 0:
			BattleLog.singleton.log(getActiveEnemyMon().rawData.name + " skipped!")
		if len(actions) == 0:
			BattleLog.singleton.log("Both sides skipped... ending turn")
			await get_tree().create_timer(0.3).timeout
			break
		var turnSequence = BattleSequence.new(actions)
		await turnSequence.runActions(self)
		hidePlayerChoiceUI(true)
		await get_tree().create_timer(0.25).timeout
		for sorted_mon in sortedActiveMonList():
			await sorted_mon.getPassive().onSubTurnStart(sorted_mon, self)
		await get_tree().create_timer(0.25).timeout
		print("state of rng_",multiplayer.get_unique_id(),":",global_rng.state)
		
	
	#0 = no one, 1 = player, 2 = enemy
	winner = 0 
	if playerLost():
		winner = 2
	if enemyLost():
		winner = 1
	
	if winner == 0:
		for mon in sortedActiveMonList():
			await mon.getPassive().onTurnEnd(mon, self)
		inTurn = false
	else:
		await endBattle(winner)
	
func endBattle(winningSide: int):
	#1 = player, 2 = enemy
	await get_tree().create_timer(0.8).timeout
	#LoadManager.loadScene("Battle", get_tree().current_scene)
	LoadManager.restoreTemp()
	


func skipTurn():
	playerCardID = -100
	emitGUISignal()

func emitGUISignal() -> void:
	gui_choice.emit()

func createDeckDisplay() -> void:
	deckController.updateDeckDisplay(len(getActivePlayerMon().currentDeck.storedCards))
	

func onHand(index: int) -> void:
	playerCardID = index

func toggleDetails() -> void:
	if showingDetails || skipButton.disabled:
		detailsPanel.hidePanel()
		showingDetails = false
	else:
		showingDetails = true
		await detailsPanel.setup(getActivePlayerMon())
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if no turn is started, start the next turn
	while (multiplayer_game && !rng_sync) || !multiplayer_loaded_peer:
			await get_tree().process_frame 
	
	if !inTurn:
		activeTurn()
	
	if Input.is_action_just_pressed("Info"):
		toggleDetails()
	pass




static func startBattle(p_playerTeam: Array[Monster], p_enemyTeam: Array[Monster], p_enemyPersonality: AIPersonality) -> void:
	

	
	playerBattleTeam = p_playerTeam
	enemyBattleTeam = p_enemyTeam
	enemyPersonality = p_enemyPersonality
	
	if multiplayer_game:
		print("waiting for connection")
		await ConnectionManager.singleton.peer.peer_connected
		
	print("setting enemy personality: ", enemyPersonality)

	LoadManager.loadSceneTemp("Battle",LoadManager.activeScene)
	pass

#Multiplayer RPC Functions

@rpc("any_peer")
func set_enemy_team(cacheArray: String):
	print(JSON.parse_string(cacheArray))
	var loadedCache: Array[int]
	loadedCache.assign(JSON.parse_string(cacheArray))
	enemyBattleTeam = monsterCache.toMonsterArray(loadedCache)
	multiplayer_loaded_peer = true
	synced.emit()
	pass

@rpc("any_peer")
func set_enemy_choice(choiceID: int, switchID: int, switching: bool):
	multiplayer_enemyActions = []
	print("player card order: ")
	for card in getActivePlayerMon().currentHand.storedCards:
		print(multiplayer.get_unique_id(),">",card.name)
	print("enemy card order: ")
	for card in getActiveEnemyMon().currentHand.storedCards:
		print(multiplayer.get_unique_id(),">",card.name)
	BattleLog.singleton.log("enemy choice id: " + str(choiceID))
	var main_action: BattleAction = await parseBattleAction(getActiveEnemyMon(), choiceID, switchID, switching, false)
	if main_action != null:
		multiplayer_enemyActions.push_back(main_action)
		if main_action.card != null:
			pass
			#getActiveEnemyMon().currentHand.removeCards([main_action.card])
	multiplayer_enemyChose = true

@rpc("any_peer")
func sync_rng(sync_seed: int, sync_state: int):
	print("seed setting:",global_rng.seed,"->",sync_seed)
	global_rng.set_seed(sync_seed)
	if global_rng.state != sync_state:
		EffectFlair.singleton._runFlair("Desynced", Color.RED)
	global_rng.state = sync_state
	rng_sync = true
	rpc("done_sync")
	
@rpc("any_peer")
func done_sync():
	rng_sync = true

@rpc("any_peer")
func send_choice(multi_choice: int):
	multiplayer_choice_buffer.push_back(multi_choice)
