extends PassiveAbility

func _init() -> void:
	name = "Refreshing Tea"
	desc = "Whenver Slocha plays a card with modified cost, draw a card, then discard a card."

#runs when a monster attacks
func beforeAttack(mon: BattleMonster, battle: BattleController, card: Card) -> void:
	if card.playedCost != card.cost:
		await createFlair(mon)
		await mon.drawCards(1)
		await mon.chooseAndDiscardCards(1)
