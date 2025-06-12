extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "To play, discard 3. Search your deck for any card and put it in your hand."
	name = "Ritualistic Sacrifice"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Rare

func canBePlayed(user: BattleMonster):
	return len(user.currentHand.storedCards) > 3

func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.chooseAndDiscardCards(3)
	var cardFromDeck = await attacker.battleController.chooseFromArray(attacker.currentDeck.storedCards, attacker.playerControlled)
	if len(cardFromDeck) > 0:
		attacker.currentDeck.storedCards.erase(cardFromDeck[0])
		attacker.currentHand.storedCards.push_back(cardFromDeck[0])

func calcBonus(attacker: BattleMonster, defender: BattleMonster, battleAI: BattleAI):
	return battleAI.STANDARD_BONUS
