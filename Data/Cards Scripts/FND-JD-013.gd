extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Draw cards until the top card of your deck has Blackjack."
	name = "Charlie"
	tags = ['Utility']
	rarity = RARITY.Legendary

func effect(attacker: BattleMonster, defender: BattleMonster):
	while true:
		if attacker.currentDeck.storedCards[0].triggersBlackjack: break
		if attacker.currentDeck.storedCards.size() == 0: break
		await attacker.drawCards(1)
	pass
