class_name CardFilter

var tagWhiteList: Array[String] = []
var tagBlackList: Array[String] = []

func _init(whiteList: Array[String] = [], blackList: Array[String] = []) -> void:
	tagWhiteList = whiteList
	tagBlackList = blackList

## Return true if the card would *not* be filtered out if run through the filter
func matchesFilter(card: Card) -> bool:
	var inWhiteList = false
	for tag in card.tags:
		if tag in tagBlackList:
			return false
		if tag in tagWhiteList:
			inWhiteList = true
	return inWhiteList

func filter(cards: Array[Card]) -> Array[Card]:
	var filtered: Array[Card] = []
	for card in cards:
		if matchesFilter(card):
			filtered.push_back(card)
	return filtered
