extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Deal (10% ATK) damage. If this Attack hits, roll a die. On a 1, 2 or 3, draw 1. On a 4, 5 or 6, draw 2."
	name = "Opening Pot"
	tags = ['Attack']
	rarity = RARITY.Rare
	power = 0.1

func effect(attacker: BattleMonster, defender: BattleMonster):
	var pureDmg = await dealDamage(attacker, defender)
	if pureDmg > 0:
		var roll = await rollDice(attacker)
		if roll < 4:
			await attacker.drawCards(1)
		else:
			await attacker.drawCards(2)
