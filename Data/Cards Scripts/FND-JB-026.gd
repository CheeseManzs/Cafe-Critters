extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Roll a die. Deal (100% ATK) damage. If you rolled a 1, take (100% ATK) damage."
	name = "Martin's Gale"
	tags = ['Attack']
	rarity = RARITY.Epic
	power = 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	var roll = await rollDice(attacker)
	if roll == 1:
		await  dealDamage(attacker, attacker)	
