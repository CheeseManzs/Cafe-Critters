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
	return len(user.currentHand.storedCards) > 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	await applyOmen(attacker, defender)
	await attacker.chooseAndDiscardCards(1)
	await attacker.drawCards(1)
	
