extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Roll a die. Deal (45% ATK) damage. if you rolled a 6, draw 1."
	name = "Lottery Lick"
	tags = ['Attack']
	rarity = RARITY.Common
	power = 0.45

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	var num = await rollDice(attacker)
	if num == 6:
		await attacker.drawCards(1)
