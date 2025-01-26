extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Haatea"
	description = "10% Attack. Gain Regen equal to damage dealt. "
	name = "Lavender Leech"
	power = 0.1

func effect(attacker: BattleMonster, defender: BattleMonster):
	var dmg = _calcPower(attacker, defender,power)
	await defender.receiveDamage(power,attacker)
	await giveStatus_noempower(attacker,Status.EFFECTS.REGEN,dmg)

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.REGEN, _calcPower(attacker, defender,power))
