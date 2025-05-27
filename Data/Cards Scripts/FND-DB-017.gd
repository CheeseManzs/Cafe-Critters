extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Deal (75% ATK) damage. This damage is doubled against block."
	name = "Piercing Strike"
	tags = ['Attack']
	rarity = RARITY.Uncommon
	power = 0.75

func effect(attacker: BattleMonster, defender: BattleMonster):
	var blocking = defender.shield > 0
	
	if blocking:
		await dealDamage(attacker, defender, power*2)
	else:
		await dealDamage(attacker, defender)
	pass

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var blocking = defender.shield > 0
	if blocking:
		return _calcPower(attacker, defender, power*2)
	else:
		return _calcPower(attacker, defender, power)
