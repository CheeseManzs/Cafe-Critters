class_name CardStorage
extends Resource
## Helper class that provides helpful functions for inventory management.

var cardNames: Array = [[], [], [], [], []]
var cardData: Array = [[], [], [], [], []]

func _init():
	pass

func addCards(resourceString: String, quantity: int = 1):
	var refCard = load("res://Data/Cards/" + resourceString + ".tres")
	var cat = refCard.tab
	var cardInd = cardNames[cat].find(resourceString)
	if cardInd == -1:
		cardNames[cat].push_back(resourceString)
		cardData[cat].push_back([refCard.index, quantity])
	else:
		cardData[cat][cardInd][1] += quantity
	
func removeCards(resourceString: String, quantity: int = 1):
	var refCard = load("res://Data/Cards/" + resourceString + ".tres")
	var cat = refCard.tab
	var cardInd = cardNames[cat].find(resourceString)
	if cardInd == -1:
		return
	else:
		cardData[cat][cardInd][1] -= quantity
		if cardData[cat][cardInd][1] <= 0:
			cardData[cat].pop_at(cardInd)
			cardNames[cat].pop_at(cardInd)
