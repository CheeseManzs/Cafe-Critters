class_name BattleMonster

static var totalDraws = 0
#link to raw monster data
@export var rawData: Monster
#current deck of the monster
@export var currentDeck: Zone
#current hand of the monster/player
@export var currentHand: Zone

@export var exileZone: Zone
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
#monster's current speed stat
@export var speed: int
#monster's current shield
@export var shield: int
@export var passive: PassiveAbility
#battle controller that instantiated the monster
var battleController: BattleController
#is monster owned by player
var playerControlled: bool
#status conditions
var statusConditions: Array[Status]
#extra cards to draw
var extraDraw = 0
var attackBonus = 0
var temp_attackBonus = 0
var defenseBonus = 0
var gameID = 0
static var damagePopupPrefab: PackedScene

func _init(data: Monster, controller: BattleController = null, p_playerControlled = true) -> void:
	#set raw data
	rawData = data
	#set the controller
	battleController = controller
	#copy data for raw data
	level = rawData.level
	shield = 0

	maxHP = rawData.getHealth()
	health = maxHP
	defense = rawData.getDefense()
	attack = rawData.getAttack()
	speed = rawData.getSpeed()
	passive = rawData.passive.duplicate()
	
	if rawData.deck.storedCards.size() == 0:
		rawData.deck = rawData.startingCardPool.clone()
	currentDeck = rawData.deck.clone()
	exileZone = Zone.new()
	playerControlled = p_playerControlled
	hardReset()
	
	if damagePopupPrefab == null:
		damagePopupPrefab = load("res://Prefabs/damage_popup.tscn")
	

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

func addAttackBonus(mod: float, temporary: bool = false):
	if temporary:
		temp_attackBonus += mod
	else:
		attackBonus += mod
	BattleLog.singleton.log(rawData.name + "'s gained " + str(100*mod) + "% Attack")

func addDefenseBonus(mod: float):
	defenseBonus += mod
	BattleLog.singleton.log(rawData.name + "'s gained " + str(100*mod) + "% Defense")

func setAttack(atk: int):
	attack = atk
	BattleLog.singleton.log(rawData.name + "'s Attack is now " + str(atk))
#removes random card and returns the removed card

func raiseAnimation():
	battleController.setCardSelection(self, false)
	for display in battleController.cardButtons:
		display.raise()
		display.ignoreInput = true
	await battleController.get_tree().create_timer(0.5).timeout

func quick_discardAnimation(card: Card) -> void:
	for display in battleController.cardButtons:
		if display.card.name == card.name:
			display.launch()
			await battleController.get_tree().create_timer(0.2).timeout
			break

func discardAnimation(card: Card) -> void:
	

	for display in battleController.cardButtons:
		display.raise()
		display.ignoreInput = true
	
	await battleController.get_tree().create_timer(1.0).timeout
	
	for display in battleController.cardButtons:
		await battleController.get_tree().create_timer(0.05).timeout
	
	await battleController.get_tree().create_timer(1.0).timeout
	
	for display in battleController.cardButtons:
		if display.card.name == card.name:
			display.raise(2)
			await battleController.get_tree().create_timer(1.0).timeout
			display.launch()
			break
	
	battleController.hidePlayerChoiceUI(true)		
	await battleController.get_tree().create_timer(0.5).timeout
	
func exileCard(card: Card):
	await discardAnimation(card)
	exileZone.storedCards.push_back(card)
	BattleLog.singleton.log(rawData.name + " exiled " + card.name)


func discardCard(card: Card, removeFromHand = true):
	await discardAnimation(card)
	battleController.addToGraveyard(card)
	BattleLog.singleton.log(rawData.name + " discarded " + card.name)
	if removeFromHand:
		currentHand.removeCards([card])
	await getPassive().onDiscard(self, battleController, card)

func pickRandomCard() -> Card:
	battleController.hidePlayerChoiceUI(true)
	await battleController.get_tree().create_timer(0.5).timeout
	battleController.setCardSelection(self,true)
	
	var cardArray = currentHand.storedCards
	
	var cards = currentHand.bulkDraw(1)
	if len(cards) == 0:
		return null
	
	var card = cards[0]
	return card

func discardRandomCard() -> Card:
	
	var picked = await pickRandomCard()
	await discardCard(picked, false)
	
	return picked
	
func exileRandomCard() -> Card:
	var picked = await pickRandomCard()
	await exileCard(picked)
	
	return picked

func playableCards() -> Array[Card]:
	var playable: Array[Card] = []
	var mp = battleController.enemyMP
	if playerControlled:
		mp = battleController.playerMP
		
	for card in currentHand.storedCards:
		if card.cost <= mp:
			playable.push_back(card)

	return playable
#check if KO'd
func isKO() -> bool:
	return hasStatus(Status.EFFECTS.KO)

#reset that happens on switch-in
func hardReset() -> void:
	shield = 0
	currentDeck = rawData.deck.clone()
	currentHand = Zone.new()
	drawCards(5)

func removeCard(card: Card):
	currentHand.removeCards([card])
	battleController.addToGraveyard(card)

func meetsRequirement(requirement: Callable) -> bool:
	for card in currentHand.storedCards:
		if requirement.call(card):
			return true
	return false
# Resets values for the start of a turn
func reset(active = true, forceDraw = false) -> void:
	if isKO():
		return
	
	#reset bonusses
	shield = 0
	attackBonus = 0
	defenseBonus = 0
	
	for i in len(statusConditions):
		var status: Status = statusConditions[i]
		status.newTurn()
	#heal from regen
	if hasStatus(Status.EFFECTS.REGEN):
		var regenStatus: Status = getStatus(Status.EFFECTS.REGEN)
		var regenAmount: int = regenStatus.X
		addHP(regenAmount)
		regenStatus.X -= 1
		if regenStatus.X <= 0:
			regenStatus.effectDone = true
	
	#remove removable status effects
	for status in statusConditions:
		if status.effectDone:
			statusConditions.remove_at(statusConditions.find(status))
	
	#move cards from hand into the deck
	currentDeck.storedCards += currentHand.bulkDraw(len(currentHand.storedCards))
	#if there are no cards in the deck, reset the deck
	if (active || forceDraw) && len(currentDeck.storedCards) == 0:
		currentDeck = rawData.deck.clone()
	
	
	#if the deck has cards and the hand has less than 5 cards, draw 1 card from the deck to the hand
	if (active || forceDraw) && len(currentDeck.storedCards) > 0:
		var drawBonus = 0
		drawBonus += floor(getKnowledge()/3.0)
		drawCards(5 + drawBonus + extraDraw)
	extraDraw = 0

func checkStatusForArray0(x) -> bool:
	return statusConditions.has(x[0])

func returnStrongarmCard():
	var exileList = []

	for card in exileZone.storedCards:
		if card.statusConditions.has(Status.EFFECTS.STRONGARM):
			exileList.push_back(card)
	if len(exileList) == 0:
		return
	await EffectFlair.singleton._runFlair("Strongarm", Color.ROYAL_BLUE)
	var rng = BattleController.global_rng
	var pickedCard: Card = exileList[rng.randi_range(0,len(exileList) - 1)]
	pickedCard.statusConditions.erase(Status.EFFECTS.STRONGARM)
	BattleLog.singleton.log(rawData.name + " got " + pickedCard.name + " back!")
	currentHand.storedCards.push_back(pickedCard)

func addStatusCondition(status: Status, broadcast = false):

	if broadcast:
		var printText = rawData.name + " was afflicted with " + status.toString()
		BattleLog.log(printText)
	
	await getPassive().onStatus(self,battleController, status)
	#if effect is ko, suspend or strongarm then it occurs immediately
	match status.effect:
		Status.EFFECTS.KO:
			await getPassive().onSelfKO(self,battleController)
		Status.EFFECTS.SUSPEND:
			var toBanish = await battleController.chooseCards(status.X,playerControlled)
			
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
		Status.EFFECTS.STRONGARM:
			if health > 0:
				await EffectFlair.singleton._runFlair("Strongarm", Color.ROYAL_BLUE)
				var removedCard: Card = await battleController.getOpposingMon(playerControlled).exileRandomCard()
				removedCard.statusConditions.push_back(Status.EFFECTS.STRONGARM)
				return
	#enemy instant effects
	if hasStatus(status.effect):
		getStatus(status.effect).X += status.X
		getStatus(status.effect).Y += status.Y
	else:
		statusConditions.push_back(status)
	
func getSpeed():
	return speed
	
func getAttack():
	return attack*(1 + attackBonus + temp_attackBonus + getPassive().attackBonus(self,battleController))

func getDefense():
	return defense*(1 + defenseBonus + getPassive().defenseBonus(self,battleController))

#carries status
func carryStatusConditions(target: BattleMonster) -> void:
	for status in statusConditions:
		if status.carriesOverOnSwitch():
			statusConditions.remove_at(statusConditions.find(status))
			target.statusConditions.push_back(status)

#adds to monster's shield
func addShield(shieldAmount: int) -> void:
	BattleLog.singleton.log(rawData.name + " gained " + str(shieldAmount) + " block")
	shield += shieldAmount
	if shield < 0:
		shield = 0
#does pure damage to the monster
func addHP(hp: int):
	BattleLog.singleton.log(rawData.name + " regenerated " + str(hp) + " HP")
	health += hp
	if health > maxHP:
		health = maxHP

func dmgAnim() -> void:
	var obj: MonsterDisplay
	if playerControlled:
		obj = battleController.playerObjs[battleController.playerTeam.find(self)]
	else:
		obj = battleController.enemyObjs[battleController.enemyTeam.find(self)]
	obj.hitAnimation()


func atkAnim(target: BattleMonster) -> void:
	var obj: MonsterDisplay = getMonsterDisplay()
	await obj.contactAnimation(target.getMonsterDisplay())

#draw cards from deck	
func drawCards(count: int) -> void:
	var card: Array[Card] = currentDeck.specialDraw(count, battleController, self)
	currentHand.storedCards += card
	if playerControlled and len(battleController.playerTeam) > 0 and battleController.getActivePlayerMon() == self:
		battleController.deckController.updateDeckDisplay(len(currentDeck.storedCards))

func getMonsterDisplay() -> MonsterDisplay:
	if playerControlled:
		return battleController.playerObjs[battleController.playerTeam.find(self)]
	else:
		return battleController.enemyObjs[battleController.enemyTeam.find(self)]

func trueDamage(dmg: int, attacker: BattleMonster = null, shielded = false) -> void:
	#remove damage from hp
	health -= dmg
	#run camera shake if damage is done
	if dmg > 0:
		var cameraMag = 0.6
		if shielded:
			cameraMag = 0.2
		BattleCamera.singleton.shake(cameraMag*dmg/float(maxHP))
		#add popup text
		var popup: DamagePopup = damagePopupPrefab.instantiate()
		
		popup.setDamage(dmg, 0.5 + 2*dmg/float(maxHP))
		var obj: MonsterDisplay = getMonsterDisplay()
		obj.get_parent().add_child(popup)
		popup.position = obj.position + Vector3(0, 0.5, 0)
		
		
		
	BattleLog.singleton.log(rawData.name + " took " + str(dmg) + " damage")
	#health cannot be negative
	if health <= 0:
		health = 0
		#add knocked out status
		BattleLog.log(rawData.name + " has been KO'd")
		if attacker != null:
			await attacker.getPassive().onOtherKO(attacker,battleController)
		await addStatusCondition(Status.new(Status.EFFECTS.KO), false)
	elif dmg > 0:
		dmgAnim()

#adds status as counter
func addCounter(eff: Status.EFFECTS, x, y = 0):
	if !hasStatus(eff):
		await addStatusCondition(Status.new(eff,0,0), true)
	var status: Status = getStatus(eff)
	status.X += x
	status.Y += y

#applies general damage
func receiveDamage(dmg:int, attacker: BattleMonster) -> int:
	if attacker != self && attacker != null:
		attacker.temp_attackBonus = 0
		await attacker.atkAnim(self)
	#play audio
	#apply barrier
	if hasStatus(Status.EFFECTS.BARRIER):
		var status = getStatus(Status.EFFECTS.BARRIER)
		BattleLog.log("Damage to " + rawData.name + " was reduced by " + status.toString())
		dmg -= status.X
		if dmg < 0:
			dmg = 0
		status.X = 0
		status.effectDone = true
	#damage shield and calculate overdamage
	var shielded = (shield > 0)
	var pureDmg = damageShield(dmg)
	if pureDmg > 0:
		battleController.playSound(battleController.hitSound)
	else:
		battleController.playSound(battleController.emptyHitSound)
	#apply overdamage to monster as true damage
	trueDamage(pureDmg, null, shielded)
	
		
	await getPassive().onHit(self,battleController)
	await attacker.getPassive().onAttack(attacker,battleController)
	return pureDmg

#get knowledge counter
func getKnowledge() -> int:
	if hasStatus(Status.EFFECTS.KNOWLEDGE):
		return getStatus(Status.EFFECTS.KNOWLEDGE).X
	return 0
#adds mp to the monster's team
func addMP(mpAmount: int, broadcast = true) -> void:
	#log mp adding
	if broadcast:
		BattleLog.singleton.log(rawData.name + "'s team gained " + str(mpAmount) + " MP")
	#if player, add mp to player variable
	if playerControlled:
		battleController.playerMP += mpAmount
		if battleController.playerMP > 6:
			battleController.playerMP = 6
	#if enemy, add mp to enemy variable
	else:
		battleController.enemyMP += mpAmount
		if battleController.enemyMP > 6:
			battleController.enemyMP = 6

func getMP() -> int:
	#if player, add mp to player variable
	if playerControlled:
		return battleController.playerMP
	#if enemy, add mp to enemy variable
	else:
		return battleController.enemyMP

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
	

#returns monster's current ability
func getPassive() -> PassiveAbility:
	return passive
	
