extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Deal (40% ATK) damage. Deal (30% ATK) damage to their shelved faes."
	name = "Cleave"
	tags = ['Attack']
	rarity = RARITY.Uncommon
	power = 0.4

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender, power)
	for mon in attacker.battleController.getTeam(defender):
		if mon != defender:
			await dealDamage(attacker, mon, 0.3)
	pass
