extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "Draw 2 extra cards next turn."
	name = "Stock Up"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var extraDraws = 2
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		extraDraws = ceil(extraDraws*1.5)
	attacker.extraDraw += extraDraws
	return 0
