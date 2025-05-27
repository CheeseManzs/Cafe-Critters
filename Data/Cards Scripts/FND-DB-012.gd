extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Deal (75% ATK) damage. If this fae swapped in this turn, deal (150% ATK) damage instead."
	name = "Follow Up"
	tags = ['Attack']
	rarity = RARITY.Uncommon
	power = 0.75

func effect(attacker: BattleMonster, defender: BattleMonster):
	
	if defender.switchState == BattleMonster.SWITCH_STATE.SWITCHED_IN:
		await dealDamage(attacker, defender, power*2)
	else:
		await dealDamage(attacker, defender)
	pass
