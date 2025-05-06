class_name CardStorage
extends Resource
## Helper class that provides helpful functions for inventory management.

var cardNames: Array = []
var cardCounts: Array = []
var cards: Array = [[], []]

func _init():
	pass

func addCards(resource: Card, quantity: int = 1):
	var cardInd = cardNames.find(resource)
	if cardInd == -1:
		cardNames.push_back(resource)
		cardCounts.push_back(quantity)
	else:
		cardCounts[cardInd] += quantity
	rebuild()
	
func removeCards(resource: Card, quantity: int = 1):
	var cardInd = cardNames.find(resource)
	if cardInd == -1:
		return
	else:
		cardCounts[cardInd] -= quantity
		if cardCounts[cardInd] <= 0:
			cardCounts.pop_at(cardInd)
			cardNames.pop_at(cardInd)
	rebuild()

func convertDeck(deck: Zone):
	cardNames = []
	cardCounts = []
	for item in deck.storedCards:
		addCards(item)
	pass
	rebuild()
	
func rebuild():
	cards = [cardNames, cardCounts]
