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
		attacker.battleController.graveyard.shuffle()
		var teamGraveyard = attacker.getTeamGraveyard()
		for i in 5:
			var card: Card = teamGraveyard[i]
			attacker.battleController.removeFromGraveyardToOwnerDeck(card)
		await attacker.addMP(1)
		await attacker.drawCards(1)
	return 
