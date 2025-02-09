extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "Gain 1 additional mp next turn."
	name = "Store Power"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#add temporary MP
	var mpNextTurn = 1
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		mpNextTurn = ceil(mpNextTurn*1.5)
	attacker.addTempMPPerTurn(mpNextTurn)
	return 0

func calcBonus(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 1
