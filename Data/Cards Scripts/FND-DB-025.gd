extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Both players shuffles all cards in their graveyard back into the decks of their respective Faes."
	name = "Recycle"
	tags = ['Utility']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	for card in attacker.battleController.graveyard:
		attacker.battleController.graveyard.erase(card)
		await card.originator.currentDeck.storedCards.push_back(card)
	BattleLog.log("All cards in the graveyard have been sent back...")
