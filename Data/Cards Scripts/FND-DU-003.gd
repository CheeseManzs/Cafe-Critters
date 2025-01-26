extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "80% Attack. If Hasted, 160% Attack instead. "
	name = "Rapid Spin"
	power = 0.8

func effect(attacker: BattleMonster, defender: BattleMonster):
	if attacker.hasStatus(Status.EFFECTS.HASTE):
		await dealDamage(attacker, defender, power*2)
	else:
		await dealDamage(attacker, defender, power)

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	if attacker.hasStatus(Status.EFFECTS.HASTE):
		return _calcPower(attacker, defender, 1.6)
	else:
		return _calcPower(attacker, defender, 0.8)
