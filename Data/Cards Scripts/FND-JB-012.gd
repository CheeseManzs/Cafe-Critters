extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Roll a die. Deal (50% ATK) damage a number of times equal to the number rolled."
	name = "Dice's Fury"
	tags = ['Attack']
	rarity = RARITY.Uncommon
	power = 0.5

func effect(attacker: BattleMonster, defender: BattleMonster):
	var roll = (await rollDice(attacker))
	for i in roll:
		await dealDamage(attacker, defender)
