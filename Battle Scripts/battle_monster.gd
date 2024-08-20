class_name BattleMonster

#link to raw monster data
@export var rawData: Monster
#current deck of the monster
@export var currentDeck: Zone
#current hand of the monster/player
@export var currentHand: Zone
#current level of the monster
@export var level: int
#current health of the monster
@export var health: int
#monster's current Max HP stat
@export var maxHP: int
#monster's current defense stat
@export var defense: int
#monster's current attack stat
@export var attack: int
#monster's current shield
@export var shield: int
#battle controller that instantiated the monster
var battleController: BattleController
#is monster owned by player
var playerControlled: bool
#status conditions
var statusConditions: Array[Status]

func _init(data: Monster, controller: BattleController = null, p_playerControlled = true) -> void:
	#set raw data
	rawData = data
	#set the controller
	battleController = controller
	#copy data for raw data
	level = 1
	shield = 0
	maxHP = rawData.statHealth
	health = maxHP
	defense = rawData.statDefense
	attack = rawData.statAttack
	currentDeck = rawData.deck.clone()
	playerControlled = p_playerControlled
	hardReset()
	

#applies damage to shield and returns overdamage
func damageShield(depletionAmount: int) -> int:
	#remove damage from shield
	shield -= depletionAmount
	#if shield takes more damage than it has, it is considered overdamage
	if shield < 0:
		#overdamage is the negative of the remaining shield
		var overdamage = -shield
		#reset shield
		shield = 0
		return overdamage
	return 0

#check for status condition
func hasStatus(eff: Status.EFFECTS) -> bool:
	for i in len(statusConditions):
		var status: Status = statusConditions[i]
		if status.effect == eff && !status.effectDone:
			return true
	return false

#returns status effect of specific type
func getStatus(eff: Status.EFFECTS) -> Status:
	for i in len(statusConditions):
		var status: Status = statusConditions[i]
		if status.effect == eff && !status.effectDone:
			return status
	return null

#check if KO'd
func isKO() -> bool:
	return hasStatus(Status.EFFECTS.KO)

#reset that happens on switch-in
func hardReset() -> void:
	shield = 0
	currentDeck = rawData.deck.clone()
	currentHand = Zone.new()


# Resets values for the start of a turn
func reset(active = true) -> void:
	shield = 0
	for i in len(statusConditions):
		var status: Status = statusConditions[i]
		status.newTurn()
	#move cards from hand into the deck
	currentDeck.storedCards += currentHand.bulkDraw(len(currentHand.storedCards))
	#if there are no cards in the deck, reset the deck
	if active && len(currentDeck.storedCards) == 0:
		BattleLog.singleton.log("Ressting cards!")
		currentDeck = rawData.deck.clone()
	
	#if the deck has cards and the hand has less than 5 cards, draw 1 card from the deck to the hand
	if active && len(currentDeck.storedCards) > 0:
		var drawBonus = 0
		drawBonus += floor(getKnowledge()/3.0)
		var card: Array[Card] = currentDeck.specialDraw(5 + drawBonus, battleController, self)
		currentHand.storedCards += card

func checkStatusForArray0(x) -> bool:
	return statusConditions.has(x[0])

func addStatusCondition(status: Status, broadcast = false):
	if broadcast:
		var printText = rawData.name + " was afflicted with " + status.toString()
		BattleLog.log(printText)
	#if effect is suspend then it occurs immediately
	if playerControlled && status.effect == Status.EFFECTS.SUSPEND:
		var toBanish = await battleController.chooseCards(status.X)
		
		battleController.banishArray(toBanish)
		currentHand.removeCards(toBanish)
		
		var graveAction: ConditionalAction = ConditionalAction.new(
			battleController,
			battleController.addArrayToGraveyard,
			checkStatusForArray0,
			toBanish,
			[self]
		)
		battleController.conditionalActions.push_back(graveAction)
	#enemy suspension
	if !playerControlled && status.effect == Status.EFFECTS.SUSPEND:
		var toBanish: Array[Card] = []
		for index in min(status.X, len(currentHand.storedCards)):
			var cardChosen = currentHand.bulkDraw(1)
			toBanish.push_back(cardChosen)
			
		battleController.banishEnemyArray(toBanish)
		currentHand.removeCards(toBanish)
		
		var graveAction: ConditionalAction = ConditionalAction.new(
			battleController,
			battleController.addArrayToGraveyard,
			checkStatusForArray0,
			toBanish,
			[self]
		)
		battleController.conditionalActions.push_back(graveAction)
	
	statusConditions.push_back(status)
	

#adds to monster's shield
func addShield(shieldAmount: int) -> void:
	shield += shieldAmount
	BattleLog.singleton.log(rawData.name + " gained " + str(shieldAmount) + " shield")
	if shield < 0:
		shield = 0
#does pure damage to the monster
func trueDamage(dmg: int) -> void:
	#remove damage from hp
	health -= dmg
	BattleLog.singleton.log(rawData.name + " took " + str(dmg) + " damage")
	#health cannot be negative
	if health <= 0:
		health = 0
		#add knocked out status
		BattleLog.log(rawData.name + " has been KO'd")
		addStatusCondition(Status.new(Status.EFFECTS.KO), false)

#adds status as counter
func addCounter(eff: Status.EFFECTS, x, y = 0):
	if !hasStatus(eff):
		addStatusCondition(Status.new(eff,0,0), true)
	var status: Status = getStatus(eff)
	status.X += x
	status.Y += y

#applies general damage
func receiveDamage(dmg:int, attacker: BattleMonster) -> int:
	#damage shield and calculate overdamage
	var pureDmg = damageShield(dmg)
	#apply overdamage to monster as true damage
	trueDamage(pureDmg)	
	return pureDmg

#get knowledge counter
func getKnowledge() -> int:
	if hasStatus(Status.EFFECTS.KNOWLEDGE):
		return getStatus(Status.EFFECTS.KNOWLEDGE).X
	return 0
#adds mp to the monster's team
func addMP(mpAmount: int) -> void:
	#log mp adding
	BattleLog.singleton.log(rawData.name + "'s team gained " + str(mpAmount) + " MP")
	#if player, add mp to player variable
	if playerControlled:
		battleController.playerMP += mpAmount
	#if enemy, add mp to enemy variable
	else:
		battleController.enemyMP += mpAmount

#adds to mp gain
func addMPPerTurn(mpGainAmount: int) -> void:
	#log mp adding
	BattleLog.singleton.log(rawData.name + "'s MP gain has increased by " + str(mpGainAmount))
	#if player, add mp gain to player variable
	if playerControlled:
		battleController.playerMPGain += mpGainAmount
	#if enemy, add mp gain to enemy variable
	else:
		battleController.enemyMPGain += mpGainAmount

func addTempMPPerTurn(mpGainAmount: int) -> void:
	#log mp adding
	BattleLog.singleton.log(rawData.name + " will gain " + str(mpGainAmount) + " more MP next turn")
	#if player, add mp gain to player variable
	if playerControlled:
		battleController.playerMPTempGain += mpGainAmount
	#if enemy, add mp gain to enemy variable
	else:
		battleController.enemyMPTempGain += mpGainAmount

func removeMP(mpAmount: int) -> void:
	#if player, remove mp from player
	if playerControlled:
		battleController.playerMP -= mpAmount
	#if enemy, remove mp from enemy
	else:
		battleController.enemyMP -= mpAmount
	
