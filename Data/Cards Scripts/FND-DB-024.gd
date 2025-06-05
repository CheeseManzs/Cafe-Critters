extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain (75% DEF) block. If this fae swapped in this turn, gain (150% DEF) block instead."
	name = "Tanking"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Uncommon
	shieldPower = 0.75

func effect(attacker: BattleMonster, defender: BattleMonster):
	if defender.switchState == BattleMonster.SWITCH_STATE.SWITCHED_IN:
		await giveShield(attacker, defender, shieldPower*2)
	else:
		await giveShield(attacker, defender, shieldPower)
	pass
