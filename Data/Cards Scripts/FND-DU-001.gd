extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "To play this card, shuffle 5 cards from your graveyard back into their respective fae's deck. Gain 1 MP and draw a card."
	name = "Stir"
	tags = ['Utility', ' Self-Target']
	rarity = RARITY.Uncommon

func canBePlayed(user: BattleMonster):
	return user.gravyardSize() >= 5

func effect(attacker: BattleMonster, defender: BattleMonster):
	if canBePlayed(attacker):
		var choices = await attacker.chooseFromGraveyard(5)
		if len(choices) > 0:
			for card in choices:
				attacker.battleController.graveyard.erase(card)
				attacker.currentDeck.storedCards.push_back(card)
		await attacker.addMP(1)
		await attacker.drawCards(1)
	return 
