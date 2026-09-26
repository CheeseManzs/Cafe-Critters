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
		# check for blackjack in deck
		if attacker.deckEmpty(): break
		if attacker.currentDeck.storedCards[0].triggersBlackjack: break
		await attacker.drawCards(1)
	if not attacker.deckEmpty():
		print("top card: ", attacker.currentDeck.storedCards[0].name)
	pass
