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
	
func transfer(target: Zone, cardID = 0) -> void:
	var card = storedCards[cardID]
	target.storedCards.push_back(card)
	storedCards.remove_at(cardID)
	pass
