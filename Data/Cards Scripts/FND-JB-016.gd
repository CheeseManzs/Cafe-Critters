extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Deal (90% ATK) damage. If this Attack hits, Gain (30% DEF) block."
	name = "Best Offense"
	tags = ['Attack']
	rarity = RARITY.Uncommon
	power = 0.9
	shieldPower = 0.3

func effect(attacker: BattleMonster, defender: BattleMonster):
	var pureDmg = await dealDamage(attacker, defender)
	if pureDmg > 0:
		await giveShield(attacker, defender)
