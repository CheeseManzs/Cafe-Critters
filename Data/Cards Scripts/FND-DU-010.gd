extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "50% Defend. If Hasted, Empower the next card played. If enemy is Slowed, 100% Defend instead."
	name = "Turtle Time"
	shieldPower = 0.5

func effect(attacker: BattleMonster, defender: BattleMonster):
	if defender.hasStatus(Status.EFFECTS.SLOW):
		await giveShield(attacker,defender,shieldPower*2)
	else:
		await giveShield(attacker,defender,shieldPower)
	
	if attacker.hasStatus(Status.EFFECTS.HASTE):
		await giveStatus(attacker,Status.EFFECTS.EMPOWER_PLAYED)

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	if defender.hasStatus(Status.EFFECTS.SLOW):
		return _calcShield(attacker,defender,shieldPower*2)
	else:
		return _calcShield(attacker,defender,shieldPower)
