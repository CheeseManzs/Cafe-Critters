extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Draw 2 cards, then put a card on top of your deck."
	name = "Stack Deck"
	tags = ['Utility']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.drawCards(2)
	var toInsert = await attacker.battleController.chooseCards(1, attacker.playerControlled)
	attacker.currentHand.storedCards.erase(toInsert[0])
	await attacker.currentDeck.insertCard(toInsert[0], 0)
	pass
