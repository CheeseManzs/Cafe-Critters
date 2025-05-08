class_name DeckVerification

static func teamIsValid(team: Array[Monster]):
	for mon in team:
		if !deckIsValid(mon.deck.storedCards, mon):
			return false
	return true

static func deckIsValid(deck: Array[Card], mon: Monster) -> bool:
	var count: Dictionary = MonsterCache.countDuplicates(deck)
	print("count: ", count)
	for card in deck:
		if card.name in count && count[card.name] > 3:
			return false
		if mon != null && card.role not in ["Basic",mon.role,mon.name]:
			return false
		if card.alignment not in [mon.alignment, card.ALIGNMENT.Default]:
			return false
	return true
