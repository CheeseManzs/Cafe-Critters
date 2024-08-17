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
func pullCard(cardID: int) -> Card:
	var card = storedCards[cardID]
	storedCards.remove_at(cardID)
	return card.clone()
	
# draws/removes random cards in bulk and returns an array
func bulkDraw(count: int) -> Array[Card]:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var cards: Array[Card] = []
	for i in min(count, len(storedCards)):
		var cardID = rng.randi_range(0, len(storedCards) - 1)
		var card = pullCard(cardID)
		cards.push_back(card)
	return cards

#bulk draws with respect to status conditions
func specialDraw(count: int, battleController: BattleController, mon: BattleMonster) -> Array[Card]:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var cards: Array[Card] = []
	for i in min(count, len(storedCards)):
		var cardID = rng.randi_range(0, len(storedCards) - 1)
		var card = pullCard(cardID)
		#check for status conditions
		for c in len(mon.statusConditions):
			var status: Status = mon.statusConditions[c]
			# if haste, then apply haste effect
			if status.effect == Status.EFFECTS.HASTE and status.X > 0:
				card.cost = max(0, card.cost - 1)
				status.X -= 1
			#if slow, then apply slow effect
			if status.effect == Status.EFFECTS.SLOW and status.X > 0:
				card.cost = max(0, card.cost + 1)
				status.X -= 1
			#if empowering next card, then empower card and mark status for removal
			if status.effect == Status.EFFECTS.EMPOWER_NEXT and !status.effectDone:
				card.statusConditions.push_back(Status.EFFECTS.EMPOWER)
				status.effectDone = true
		#add card to cards array
		cards.push_back(card)
	return cards
	
#directly transfers cards between zones
func transfer(target: Zone, cardID = 0) -> void:
	var card = storedCards[cardID]
	target.storedCards.push_back(card)
	storedCards.remove_at(cardID)
	pass
