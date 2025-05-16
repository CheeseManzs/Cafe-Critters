extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Guard"
	description = "Target player shuffles all cards in their graveyard back into the decks of their respective Faes."
	name = "Recycle"

func effect(attacker: BattleMonster, defender: BattleMonster):
	for card in attacker.battleController.graveyard:
		if card.originator != null && card.originator.playerControlled == attacker.playerControlled:
			card.originator.currentDeck.storedCards.append(card)
			attacker.battleController.graveyard.erase(card)
	BattleLog.log("All cards in the graveyard have been restored")
	await attacker.battleController.get_tree().create_timer(1.0).timeout
	return
