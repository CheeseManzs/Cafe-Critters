class_name Zone
extends Resource


# name of zone (graveyard, hand, deck, etc.)
@export var name: String

# what cards are in the zone
# zones ordered like a stack: the first item in the zone is the top of this stack
@export var storedCards: Array[Card]

func clone() -> Zone:
	var newZone: Zone = Zone.new()
	newZone.name = name
	newZone.storedCards = []
	newZone.storedCards += storedCards
	return newZone

# draws a card from target zone, useful for drawing from a hand or a graveyard
func draw(target: Zone, cardID = 0) -> void:
	if cardID < target.storedCards.size():
		var selected = target.storedCards[cardID]
	pass

#removes a card from the deck and returns it
func pullCard(cardID: int, tempArray: Array[Card] = storedCards) -> Card:
	var card = tempArray[cardID]
	print("erasing ", card.name)
	storedCards.erase(card)
	tempArray.erase(card)
	print("erasing -> ", len(storedCards))
	return card.clone()

#remove list of cards
func removeCards(cards: Array[Card]):
	
	for card in cards.duplicate():
		print("removing " + card.name)
		if storedCards.has(card):
			storedCards.erase(card)
			print("removed!")
			if card.originator != null:
				await card.originator.battleController.addToGraveyard(card, card.originator)

func exileCards(cards: Array[Card], mon: BattleMonster):
	for card in cards.duplicate():
		if storedCards.has(card):
			BattleLog.singleton.log("found card to exile")
			storedCards.remove_at(storedCards.find(card))
			mon.exileZone.storedCards.push_back(card)

# draws/removes random cards in bulk and returns an array
func bulkDraw(count: int, filter: CardFilter = CardFilter.new()) -> Array[Card]:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	if BattleController.multiplayer_game:
		rng = BattleController.global_rng
	var cards: Array[Card] = []
	var filterArray = filter.filter(storedCards)
	print("------erasing-----")
	for i in min(count, len(filterArray)):
		var cardID = rng.randi_range(0, len(filterArray) - 1)
		var card = pullCard(cardID, filterArray)
		cards.push_back(card)
	print("--------erasing done--------")
	return cards


#bulk draws with respect to status conditions
func specialDraw(count: int, battleController: BattleController, mon: BattleMonster, filter: CardFilter = CardFilter.new()) -> Array[Card]:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	if BattleController.multiplayer_game:
		rng = BattleController.global_rng

	var cards: Array[Card] = []
	var drawArray = filter.filter(storedCards)
	
	for i in min(count, len(drawArray)):
		var oldState = rng.state
		var cardID = rng.randi_range(0, len(drawArray) - 1)
		if oldState == rng.state:
			print("state not changed! > ",BattleMonster.totalDraws)
		var card = pullCard(cardID, drawArray)
		#check for status conditions
		if mon.hasStatus(Status.EFFECTS.EMPOWER_NEXT, card):
			card.statusConditions.push_back(Status.EFFECTS.EMPOWER)
			mon.getStatus(Status.EFFECTS.EMPOWER_NEXT).effectDone = true
		if mon.hasStatus(Status.EFFECTS.FOCUS, card):
			card.costMod -= 1
			if !mon.hasStatus(Status.EFFECTS.CAFFEINATED_OVERDRIVE):
				mon.getStatus(Status.EFFECTS.FOCUS).addX(-1)
		if mon.hasStatus(Status.EFFECTS.FATIGUE, card):
			card.costMod += 1
			mon.getStatus(Status.EFFECTS.FATIGUE).addX(-1)
		#add card to cards array
		cards.push_back(card)
	
	return cards
	
#directly transfers cards between zones
func transfer(target: Zone, cardID = 0) -> void:
	var card = storedCards[cardID]
	target.storedCards.push_back(card)
	storedCards.remove_at(cardID)
	pass
	
static func getTaggedCardsInArray(arr: Array[Card], tag: String):
	var returnArray = []
	print("tag search: start")
	for card in arr:
		print("tag search: ",card.name,":",card.tags," e ",tag," -> ",card.tags.has(tag))
		if card.tags.has(tag):
			returnArray.push_back(card)
	return returnArray
	
static func getRoleCardsInArray(arr: Array[Card], role: String):
	var returnArray = []
	for card in arr:
		if card.role == role:
			returnArray.push_back(card)
	return returnArray
	
static func getRandomTaggedCardInArray(arr: Array[Card], tag: String) -> Card:
	var taggedArr = getTaggedCardsInArray(arr, tag)
	if len(taggedArr) == 0:
		return null
	else:
		return taggedArr[BattleController.global_rng.randi_range(0, len(taggedArr) - 1)] 

static func getRandomRoleCardInArray(arr: Array[Card], role: String) -> Card:
	var taggedArr = getRoleCardsInArray(arr, role)
	if len(taggedArr) == 0:
		return null
	else:
		return taggedArr[BattleController.global_rng.randi_range(0, len(taggedArr) - 1)] 

func getRandomTaggedCard(tag: String) -> Card:
	return getRandomTaggedCardInArray(storedCards, tag)
	
func getRandomRoleCard(role: String) -> Card:
	return getRandomRoleCardInArray(storedCards, role)

func getRoleCards(role: String) -> Card:
	return getRandomRoleCardInArray(storedCards, role)
