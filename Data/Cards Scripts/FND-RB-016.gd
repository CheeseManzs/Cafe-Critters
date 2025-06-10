extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "If a Utility has been placed into your graveyard this turn, draw 4, then discard 2 unless you discard a Utility. "
	name = "Hidden Technique"
	tags = ['Utility']
	rarity = RARITY.Uncommon

func canBePlayed(user: BattleMonster):
	var utilCards = Zone.getTaggedCardsInArray(user.addedToGraveyardThisTurn, "Utility")
	return len(utilCards) > 0

func effect(attacker: BattleMonster, defender: BattleMonster):
	var utilCards = Zone.getTaggedCardsInArray(attacker.addedToGraveyardThisTurn, "Utility")
	if len(utilCards) > 0:
		await attacker.drawCards(4)
		var cardList = await attacker.chooseAndDiscardCards(1)
		if len(cardList) > 0 && "Utility" not in cardList[0].tags:
			await attacker.chooseAndDiscardCards(1)
