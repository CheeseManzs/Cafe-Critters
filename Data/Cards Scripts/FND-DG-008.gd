extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Guard"
	description = "75% Defend. If Tagged, 150% Defend instead. "
	name = "Tanking"
	shieldPower = 0.75

func effect(attacker: BattleMonster, defender: BattleMonster):
	shieldPower = 0.75
	if attacker.hasStatus(Status.EFFECTS.TAGGED):
		shieldPower = 1.5
	
	await giveShield(attacker, defender, shieldPower,true)
	return

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	if attacker.hasStatus(Status.EFFECTS.TAGGED):
		return _calcShield(attacker, defender, 1.5, true)
	else:
		return _calcShield(attacker, defender, 0.75, true)
