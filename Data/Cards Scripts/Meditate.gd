extends Card

func _init() -> void:
	cost = 4
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "Gain an additional 1 mp per turn for the rest of the game."
	name = "Meditate"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var mpBonus = 1
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		mpBonus = ceil(mpBonus*1.5)
	attacker.addMPPerTurn(mpBonus)
	return 0

func calcBonus(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 6
