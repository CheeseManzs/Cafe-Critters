class_name DeckVerification

static func teamIsValid(team: Array[Monster]):
	for mon in team:
		if !deckIsValid(mon.deck.storedCards):
			return false
	return true

static func deckIsValid(deck: Array[Card]) -> bool:
	var count: Dictionary = MonsterCache.countDuplicates(deck)
	print("count: ", count)
	for card in deck:
		if card.name in count && count[card.name] > 3:
			return false
	return true
