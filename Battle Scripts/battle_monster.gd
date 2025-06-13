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
@export var heldItem: HeldItem
#battle controller that instantiated the monster
var battleController: BattleController
#is monster owned by player
var playerControlled: bool
#status conditions
var statusConditions: Array[Status]
#play history
var playedCardHistory: Array[Card]
var addedToGraveyardThisTurn: Array[Card]
var playedCardThisTurn = false
var wasAttackedThisTurn = false
var cardsSentToGraveyard = false
#extra cards to draw
var extraDraw = 0
var attackBonus = 0
var temp_attackBonus = 0
var defenseBonus = 0
var gameID = 0
var parryPower = 0
var canDraw = true

enum SWITCH_STATE {
	NONE,
	SWITCHED_IN,
	SWITCHED_OUT
}

var switchState: SWITCH_STATE = SWITCH_STATE.NONE

static var damagePopupPrefab: PackedScene

func _init(data: Monster, controller: BattleController = null, p_playerControlled = true) -> void:
	#set raw data
	rawData = data
	#set the controller
	battleController = controller
	#copy data for raw data
	level = rawData.level
	shield = 0
	
	heldItem = data.heldItem
	if heldItem == null:
		heldItem = HeldItem.NONE.duplicate()
		
	var itemBoosts: Array[int] = heldItem.getBoost(data)
	
	maxHP = rawData.getHealth() + itemBoosts[0]
	health = maxHP
	attack = rawData.getAttack() + itemBoosts[1]
	defense = rawData.getDefense() + itemBoosts[2]
	speed = rawData.getSpeed() + itemBoosts[3]
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

#remove status
func removeStatus(eff: Status.EFFECTS):
	for status in statusConditions:
		if status.effect == eff:
			BattleLog.log(getName() + " lost " + status.rawToString())
			status.effectDone = true
#check for status condition
func hasStatus(eff: Status.EFFECTS, card: Card = null) -> bool:
	for i in len(statusConditions):
		var status: Status = statusConditions[i]
		if status.effect == eff && !status.effectDone && (card == null || status.filter.matchesFilter(card)):
			return true
	return false

func canSwitchOut() -> bool:
	if hasStatus(Status.EFFECTS.TRAPPED):
		return false
	return true
	
func canSwitchIn() -> bool:
	return true
	
func onSwitchOut() -> void:
	return
	
func onSwitchIn() -> void:
	if hasStatus(Status.EFFECTS.MISSING_OUT):
		var dmg = maxHP*0.1
		trueDamage(dmg, null, false, false)

#returns status effect of specific type
func getStatus(eff: Status.EFFECTS) -> Status:
	for i in len(statusConditions):
		var status: Status = statusConditions[i]
		if status.effect == eff && !status.effectDone:
			return status
	return null

func binaryBoostAnim(score, message = ""):
	var obj: MonsterDisplay = getMonsterDisplay()
	await BattleCamera.singleton.focusMonster(self)
	if message != "":
		BattleLog.singleton.log(message)
	if score >= 0:
		battleController.playSound(battleController.powerUpSound)
		obj.boostParticles.emitting = true
	else:
		battleController.playSound(battleController.powerDownSound)
		obj.unboostParticles.emitting = true
	while obj.boostParticles.emitting || obj.unboostParticles.emitting:
			await battleController.get_tree().process_frame
	await battleController.get_tree().create_timer(0.5).timeout
	BattleCamera.singleton.disableFocus()

func addAttackBonus(mod: float, temporary: bool = false):
	await binaryBoostAnim(mod, rawData.name + "'s gained " + str(100*mod) + "% Attack")
	if temporary:
		temp_attackBonus += mod
	else:
		attackBonus += mod

func addDefenseBonus(mod: float):
	await binaryBoostAnim(mod, rawData.name + "'s gained " + str(100*mod) + "% Defense")
	defenseBonus += mod

func setAttack(atk: int):
	await binaryBoostAnim(atk - attack, rawData.name + "'s Attack is now " + str(atk))
	attack = atk
	
#removes random card and returns the removed card

func raiseAnimation():
	battleController.setCardSelection(self, false)
	for display in battleController.cardButtons:
		display.raise()
		display.ignoreInput = true
	await battleController.get_tree().create_timer(0.5).timeout
	
func lowerAnimation():
	battleController.hidePlayerChoiceUI(true)
	await battleController.get_tree().create_timer(0.5).timeout

func quick_discardAnimation(card: Card) -> void:
	for display in battleController.cardButtons:
		if display.card == card:
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
		if display.card == card || (display.card.name == card.name):
			display.raise(2)
			await battleController.get_tree().create_timer(1.0).timeout
			display.launch()
			break
	
	battleController.hidePlayerChoiceUI(true)		
	await battleController.get_tree().create_timer(0.5).timeout

func exileCard(card: Card, discardAnim = true):
	if card == null:
		return
	if discardAnim:
		await discardAnimation(card)
	exileZone.storedCards.push_back(card)
	BattleLog.singleton.log(rawData.name + " exiled " + card.name)

func gravyardSize():
	var s = 0
	for card in battleController.graveyard:
		if card.originator != null && card.originator.playerControlled == playerControlled:
			s += 1
	return s
	
func getTeamGraveyard() -> Array[Card]:
	var teamGraveyard: Array[Card] = []
	for card in battleController.graveyard:
		if card.originator != null && card.originator.playerControlled == playerControlled:
			teamGraveyard.push_back(card)
	return teamGraveyard

func randomGraveyardCardFromTeam(removeCard = false) -> Card:
	var canPull = []
	for card in battleController.graveyard:
		if card.originator != null && card.originator.playerControlled == playerControlled:
			canPull.append(card)
	if len(canPull) == 0:
		return null
	var pulled = canPull[battleController.global_rng.randi_range(0, len(canPull) - 1)]
	if removeCard:
		battleController.graveyard.erase(pulled)
	return pulled

func discardCard(card: Card, removeFromHand = true, playAnimation = true):
	if card == null:
		return
	if playAnimation:
		await discardAnimation(card)
	await battleController.addToGraveyard(card, self)
	BattleLog.singleton.log(rawData.name + " discarded " + card.name)
	if removeFromHand:
		await currentHand.removeCards([card])
	await getPassive().onDiscard(self, battleController, card)
	await getHeldItem().getPassive().onDiscard(self, battleController, card)

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

func getName() -> String:
	return rawData.name

func discardRandomCard() -> Card:
	
	var picked = await pickRandomCard()
	await discardCard(picked, false)
	
	return picked
	
func discardRandomTokenCard() -> Card:
	
	var picked = await currentHand.getRandomRoleCard("Token")
	if picked == null:
		return null
	currentHand.storedCards.erase(picked)
	await discardCard(picked, false)
	return picked
	
func discardRandomTaggedCard(tag: String) -> Card:
	var picked = await currentHand.getRandomTaggedCard(tag)
	if picked == null:
		return null
	currentHand.storedCards.erase(picked)
	await discardCard(picked, false)
	return picked

func exileRandomDeckCards(count: int) -> Array:
	var randomCards = await currentDeck.bulkDraw(count)
	for card in randomCards:
		await exileCard(card, false)
	return randomCards

func exileRandomCard() -> Card:
	var picked = await pickRandomCard()
	await exileCard(picked)
	
	return picked

func addHeat(x):
	if getPassive() is MachineAbility:
		var passive: MachineAbility = getPassive()
		await passive.setHeat(passive.heat + x, self, battleController)
		
func getHeat():
	if getPassive() is MachineAbility:
		var passive: MachineAbility = getPassive()
		return passive.heat
	return 0

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

func removeCard(card: Card):
	await currentHand.removeCards([card])
	await battleController.addToGraveyard(card, self)

func meetsRequirement(requirement: Callable) -> bool:
	for card in currentHand.storedCards:
		if requirement.call(card):
			return true
	return false
# Resets values for the start of a turn
func reset(active = true, forceDraw = false) -> void:
	if isKO():
		return
	canDraw = true
	playedCardThisTurn = false
	wasAttackedThisTurn = false
	cardsSentToGraveyard = 0
	addedToGraveyardThisTurn = []
	#eternal guardians
	if hasStatus(Status.EFFECTS.ETERNAL_GUARDIANS):
		for card in getTeamGraveyard():
			if card.name == "Eternal Guardians":
				var etgShield = getDefense()*0.1
				await addShield(etgShield)
	#reset bonusses
	shield = 0
	attackBonus = 0
	defenseBonus = 0
	parryPower = 0
	
	for i in len(statusConditions):
		var status: Status = statusConditions[i]
		status.newTurn()
	#update status icon
	getMonsterDisplay().updateStatusConditions()
	#heal from regen
	if hasStatus(Status.EFFECTS.REGEN):
		var regenStatus: Status = getStatus(Status.EFFECTS.REGEN)
		var regenAmount: int = regenStatus.X*0.01*maxHP
		await addHP(regenAmount)
		regenStatus.addX(-1)
	
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
		standardDraw()
	

func standardDraw():
	if canDraw:
		var drawBonus = 0
		drawBonus += floor(getKnowledge()/3.0)
		drawCards(5 + drawBonus + extraDraw)
		extraDraw = 0
		canDraw = false

func chooseAndDiscardCards(count: int) -> Array[Card]:
	var toDiscard = await battleController.chooseCards(count, playerControlled)
	for card in toDiscard:
		await discardCard(card,true,false)
	await battleController.get_tree().create_timer(1.0).timeout
	return toDiscard


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

func onSkip():
	if hasStatus(Status.EFFECTS.FIGHT_OR_FLIGHT):
		await EffectFlair.singleton._runFlair("Fight or Flight", Color.DARK_RED)
		var dmg = 0.1*maxHP*getStatus(Status.EFFECTS.FIGHT_OR_FLIGHT).X
		await trueDamage(dmg, null,false,false)

func addStatusCondition(status: Status, broadcast = false):
	if isKO():
		return
		
	var obj: MonsterDisplay = getMonsterDisplay()
	
	if broadcast:
		await BattleCamera.singleton.focusMonster(self)
		var printText = rawData.name + " was afflicted with " + status.toString()
		if status.isPositive():
			printText = rawData.name + " was embued with " + status.toString()
			battleController.playSound(battleController.powerUpSound)
			obj.boostParticles.emitting = true
		else:
			battleController.playSound(battleController.powerDownSound)
			obj.unboostParticles.emitting = true
		BattleLog.log(printText)
		while obj.boostParticles.emitting || obj.unboostParticles.emitting:
			await battleController.get_tree().process_frame
		await battleController.get_tree().create_timer(0.5).timeout
		BattleCamera.singleton.disableFocus()
	
	await getPassive().onStatus(self,battleController, status)
	await getHeldItem().getPassive().onStatus(self,battleController, status)
	#if effect is ko, suspend or strongarm then it occurs immediately
	match status.effect:
		Status.EFFECTS.KO:
			await getPassive().onSelfKO(self,battleController)
			await getHeldItem().getPassive().onSelfKO(self,battleController)
		Status.EFFECTS.SUSPEND:
			var toBanish = await battleController.chooseCards(status.X,playerControlled)
			
			battleController.banishArray(toBanish)
			await currentHand.removeCards(toBanish)
			
			var graveAction: ConditionalAction = ConditionalAction.new(
				battleController,
				battleController.addArrayToGraveyard,
				checkStatusForArray0,
				toBanish,
				[self]
			)
			battleController.conditionalActions.push_back(graveAction)
	#enemy instant effects
	if hasStatus(status.effect):
		var newStatus = getStatus(status.effect)
		if status.X > 0:
			newStatus.addX(status.X)
		if status.Y > 0:
			newStatus.Y += status.Y
	else:
		statusConditions.push_back(status)
	
	obj.updateStatusConditions()
	
func getSpeed():
	return speed
	
func getAttack():
	var atkUpBonus = 0
	if hasStatus(Status.EFFECTS.ATTACK_UP):
		atkUpBonus = 0.05*getStatus(Status.EFFECTS.ATTACK_UP).X
	
	var cardBonus = 0
	
	if hasCardInHand("The Bluff"):
		cardBonus += 0.2
	
	return attack*(1 + attackBonus + temp_attackBonus + atkUpBonus + cardBonus + getPassive().attackBonus(self,battleController) + getHeldItem().getPassive().attackBonus(self,battleController))

func getDefense():
	var defUpBonus = 0
	if hasStatus(Status.EFFECTS.DEFENSE_UP):
		defUpBonus = 0.05*getStatus(Status.EFFECTS.DEFENSE_UP).X
	
	return defense*(1 + defenseBonus + defUpBonus + getPassive().defenseBonus(self,battleController) + getHeldItem().getPassive().defenseBonus(self,battleController))

func chooseFromGraveyard(cardCount: int):
	return (await battleController.chooseFromGraveyard(playerControlled, cardCount))

func tryParry(target: BattleMonster):
	if parryPower > 0:
		var dmg = ceil(parryPower*getAttack())
		parryPower = 0
		await target.receiveDamage(dmg, self)

func hasCardInHand(cardName: String):
	for card in currentHand.storedCards:
		if card.name == cardName:
			return true
	return false

#carries status
func carryStatusConditions(target: BattleMonster) -> void:
	for status in statusConditions.duplicate():
		if status.carriesOverOnSwitch():
			statusConditions.erase(status)
			getMonsterDisplay().removeStatusIcon(status)
			target.addStatusCondition(status,false)
	getMonsterDisplay().updateStatusConditions()
	target.getMonsterDisplay().updateStatusConditions()

#adds to monster's shield
func addShield(shieldAmount: int) -> void:
	BattleLog.singleton.log(rawData.name + " gained " + str(shieldAmount) + " block")
	shield += shieldAmount
	#play sound
	battleController.playSound(battleController.shieldSound)
	if shield < 0:
		shield = 0
	await battleController.get_tree().create_timer(1.0).timeout
#does pure damage to the monster
func addHP(hp: int):
	BattleLog.singleton.log(rawData.name + " regenerated " + str(hp) + " HP")
	health += hp
	battleController.playSound(battleController.powerUpSound)
	if health > maxHP:
		health = maxHP
	await battleController.get_tree().create_timer(1.0).timeout

func dmgAnim() -> void:
	var obj: MonsterDisplay
	if playerControlled:
		obj = battleController.playerObjs[battleController.playerTeam.find(self)]
	else:
		obj = battleController.enemyObjs[battleController.enemyTeam.find(self)]
	await obj.hitAnimation()


func atkAnim(target: BattleMonster) -> void:
	var obj: MonsterDisplay = getMonsterDisplay()
	await BattleCamera.singleton.focusMonsters([self, target], 1.2, 0)
	await obj.contactAnimation(target.getMonsterDisplay())
	BattleCamera.singleton.disableFocus()

func getOmenCards() -> Array[Card]:
	var cards: Array[Card] = []
	for _card in Zone.getTaggedCardsInArray(battleController.graveyard, "Omen"):
		var card: Card = _card
		if card.originator == self:
			cards.push_back(card)
	return cards
	
func getRoleCardsInHand(role: String):
	return Zone.getRoleCardsInArray(currentHand.storedCards, role)
		
func discardHand(filter: CardFilter = CardFilter.new()) -> void:
	var discardCards = filter.filter(currentHand.storedCards)
	await raiseAnimation()
	var cardCount = len(discardCards)
	for i in range(len(discardCards)):
		await quick_discardAnimation(discardCards[i])
		await getPassive().onDiscard(self,battleController,discardCards[i])
		await getHeldItem().getPassive().onDiscard(self,battleController,discardCards[i])
		currentHand.storedCards.erase(discardCards[i])
	
	await lowerAnimation()

#draw cards from deck	
func drawCards(count: int, filter: CardFilter = CardFilter.new()) -> Array[Card]:
	var card: Array[Card] = currentDeck.specialDraw(count, battleController, self, filter)
	currentHand.storedCards += card
	if playerControlled and len(battleController.playerTeam) > 0 and battleController.getActivePlayerMon() == self:
		battleController.deckController.updateDeckDisplay(len(currentDeck.storedCards))
	return card

func millCards(count: int) -> void:
	var card: Array[Card] = currentDeck.specialDraw(count, battleController, self)
	await battleController.addArrayToGraveyard(card, self)
	
func shuffleCardIntoDeck(card: Card, index: int) -> void:
	if index == -1:
		index = randi() % currentDeck.storedCards.size()
	await currentDeck.storedCards.insert(index, card)

func getStatusLevel(effectType: Status.EFFECTS) -> int:
	var x: int = 0
	if hasStatus(effectType):
		x = getStatus(effectType).X
	return x 

func getActiveTeammate():
	if playerControlled:
		return battleController.getActivePlayerMon()
	else:
		return battleController.getActiveEnemyMon()

func promptSwitch():
	if playerControlled:
		await battleController.promptPlayerSwitch()
	else:
		await battleController.promptEnemySwitch()


func getMonsterDisplay() -> MonsterDisplay:
	if playerControlled:
		return battleController.playerObjs[battleController.playerTeam.find(self)]
	else:
		return battleController.enemyObjs[battleController.enemyTeam.find(self)]

func checkNullifyDamage():
	if hasStatus(Status.EFFECTS.NULLIFY_DAMAGE):
		getStatus(Status.EFFECTS.NULLIFY_DAMAGE).effectDone = true
		BattleLog.singleton.log(rawData.name + " dodged the attack!")
		return true
	return false

func trueDamage(dmg: int, attacker: BattleMonster = null, shielded = false, damageAnim = true, blackListedSources = []) -> void:
	if isKO():
		return
	#check nullify again for true damage
	if checkNullifyDamage():
		return
	if dmg > 0:
		wasAttackedThisTurn = true
		battleController.playSound(battleController.hitSound)
	#remove damage from hp
	health -= dmg
	
	#save damage dealt this turn
	if attacker != null:
		battleController.registerDamage(attacker, dmg)
	
	#run camera shake if damage is done
	if dmg > 0:
		var cameraMag = 0.6
		if shielded:
			cameraMag = 0.2
		
		BattleCamera.singleton.shake(cameraMag*min(1, dmg/float(maxHP)))
			
		#add popup text
		var popup: DamagePopup = damagePopupPrefab.instantiate()
		
		popup.setDamage(dmg, 0.5 + 2*min(1, dmg/float(maxHP)))
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
			await getHeldItem().getPassive().onOtherKO(attacker,battleController)
		await addStatusCondition(Status.new(Status.EFFECTS.KO), false)
	elif dmg > 0 and damageAnim:
		await dmgAnim()
	
	#insurace
	if health > 0 && dmg <= 0 && attacker != null && attacker.hasStatus(Status.EFFECTS.INSURANCE):
		#blackListedSources.push_back(Status.EFFECTS.INSURANCE)
		var insuranceDamage = maxHP*0.15*attacker.getDefense()
		await trueDamage(insuranceDamage, attacker, shielded, true, blackListedSources)
	
	#fear
	if health > 0 && hasStatus(Status.EFFECTS.FEAR) && Status.EFFECTS.FEAR not in blackListedSources && dmg > 0:
		await EffectFlair.singleton._runFlair("Fear", Color.MIDNIGHT_BLUE)
		var fearStatus = getStatus(Status.EFFECTS.FEAR)
		var fearDamage = maxHP*0.01*fearStatus.X
		blackListedSources.push_back(Status.EFFECTS.FEAR)
		await trueDamage(fearDamage, null, shielded, false, blackListedSources)
		fearStatus.addX(-1)
	
	if health > 0 && hasStatus(Status.EFFECTS.FEAR) && Status.EFFECTS.FEAR not in blackListedSources && dmg <= 0:
		var fearStatus = getStatus(Status.EFFECTS.FEAR)
		fearStatus.effectDone = true
	
		#step back
	if health > 0 && hasStatus(Status.EFFECTS.STEP_BACK) && dmg == 0:
		await addMP(2)
		await addAttackBonus(0.2, true)
	
	#the bluff
	if health > 0 && dmg > 0 && hasCardInHand("The Bluff"):
		var toDiscard: Card = null
		for card in currentHand.storedCards:
			if card.name == "The Bluff":
				toDiscard = card
				break
		await discardCard(toDiscard)
	
	if attacker != null:
		#crashout
		if health > 0 && attacker.hasStatus(Status.EFFECTS.CRASHOUT) && dmg == 0 && Status.EFFECTS.CRASHOUT not in blackListedSources:
			var crashoutDmg = attacker.getAttack()*0.25
			blackListedSources.push_back(Status.EFFECTS.CRASHOUT)
			await battleController.get_tree().create_timer(1.0).timeout
			await receiveDamage(crashoutDmg,attacker,blackListedSources)

#adds status as counter
func addCounter(eff: Status.EFFECTS, x, y = 0):
	if !hasStatus(eff):
		await addStatusCondition(Status.new(eff,0,0), true)
	var status: Status = getStatus(eff)
	status.addX(x)
	status.Y += y

func execute():
	await trueDamage(maxHP)

#applies general damage
func receiveDamage(dmg:int, attacker: BattleMonster, blacklistedSources = []) -> int:
	#apply damage multiplier
	dmg *= battleController.damageMultiplier
	if isKO():
		return 0
	if attacker != self && attacker != null:
		attacker.temp_attackBonus = 0
		await attacker.atkAnim(self)
	#play audio
	#apply nullify
	if checkNullifyDamage():
		battleController.playSound(battleController.emptyHitSound)
		return 0
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
		pass
	else:
		battleController.playSound(battleController.emptyHitSound)
	#apply overdamage to monster as true damage
	await trueDamage(pureDmg, attacker, shielded, true, blacklistedSources)
	
		
	await getPassive().onHit(self,battleController)
	await getHeldItem().getPassive().onHit(self,battleController)
	await attacker.getPassive().onAttack(attacker,battleController)
	await attacker.getHeldItem().getPassive().onAttack(attacker,battleController)
	
	#after attacks, try parrying
	if attacker != self && attacker != null:
		await tryParry(attacker)
	
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
		battleController.playSound(battleController.powerUpSound)
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
	battleController.playSound(battleController.powerUpSound)
	#if player, add mp gain to player variable
	if playerControlled:
		battleController.playerMPGain += mpGainAmount
	#if enemy, add mp gain to enemy variable
	else:
		battleController.enemyMPGain += mpGainAmount

func addTempMPPerTurn(mpGainAmount: int) -> void:
	#log mp adding
	BattleLog.singleton.log(rawData.name + " will gain " + str(mpGainAmount) + " more MP next turn")
	battleController.playSound(battleController.powerUpSound)
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

#returns monster's current held item
func getHeldItem() -> HeldItem:
	return heldItem
