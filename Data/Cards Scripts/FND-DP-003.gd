extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Point"
	description = "Gain Haste 2. If Hasted, gain Haste 5 instead. "
	name = "Bolster"

func effect(attacker: BattleMonster, defender: BattleMonster):
	if attacker.hasStatus(Status.EFFECTS.HASTE):
		await giveStatus(attacker,Status.EFFECTS.HASTE,5)
	else:
		await giveStatus(attacker,Status.EFFECTS.HASTE,2)
