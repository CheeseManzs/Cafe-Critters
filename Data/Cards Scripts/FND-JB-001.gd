extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Roll a die. Deal (90% ATK) damage. If you rolled a 4, 5, or 6, deal (125% ATK) damage instead."
	name = "Lucky Shot"
	tags = ['Attack']
	rarity = RARITY.Common
	power = 0.9

func effect(attacker: BattleMonster, defender: BattleMonster):
	var num = await rollDice(attacker)
	if num > 3:
		await dealDamage(attacker, defender, 1.25)
	else:
		await dealDamage(attacker, defender, 0.9)
