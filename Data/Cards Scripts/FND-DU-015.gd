extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Haatea"
	description = "Consume all mp. (10% per mp consumed) Attack. Gain 1 Regen per mp consumed. "
	name = "Trunk Shot"

func effect(attacker: BattleMonster, defender: BattleMonster):
	var mpCount = attacker.getMP()
	attacker.addMP(-mpCount, false)
	await dealDamage(attacker,defender,0.1*mpCount)
	await giveStatus(attacker,Status.EFFECTS.REGEN,mpCount)

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	return _calcPower(attacker, defender, 0.1*attacker.getMP())

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.REGEN,attacker.getMP())
