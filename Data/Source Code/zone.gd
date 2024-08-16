class_name Zone
extends Resource


# name of zone (graveyard, hand, deck, etc.)
var name: String

# what cards are in the zone
# zones ordered like a stack: the first item in the zone is the top of this stack
var storedCards: Array

# draws a card from target zone, useful for drawing from a hand or a graveyard
func draw(target: Zone, cardID = 0) -> void:
	if cardID < target.storedCards.size():
		var selected = target.storedCards[cardID]
	pass
	
func transfer(target, cardID = 0) -> void:
	
	pass
