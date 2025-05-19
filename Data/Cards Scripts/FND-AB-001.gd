extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Basic"
	description = "As an additional cost to play this card, discard a card from your hand. Create Scrap equal to that card's mana cost."
	name = "Scrap"
func canBePlayed(user: BattleMonster):
	return len(user.currentHand) >= 2


func effect(attacker: BattleMonster, defender: BattleMonster):
	var cards = await attacker.battleController.chooseCards(1,attacker.playerControlled)
	
	if len(cards) == 0:
		return
	var card = cards[0]
	await attacker.discardCard(card, true, false)
	for mp in card.cost:
		attacker.currentHand.storedCards.push_back(createInstance("Scrap (Token)"))
	BattleLog.log(attacker.rawData.name + " salvaged " + str(card.cost) + " scrap")
	pass
