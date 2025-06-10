extends Card

func _init() -> void:
	cost = 0
	priority = 1
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Discard 1, then draw 1."
	name = "Pay the Price"
	tags = ['Utility', 'Self-Target', 'Omen']
	rarity = RARITY.Uncommon

func canBePlayed(user: BattleMonster):
	return len(user.currentHand.storedCards) >= 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	var toDiscard = await defender.battleController.chooseCards(1, defender.playerControlled)
	if len(toDiscard) > 0:
		await defender.discardCard(toDiscard[0])
	await attacker.drawCards(1)
	await applyOmen(attacker, defender)
