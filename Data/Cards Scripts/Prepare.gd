extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Point
	description = "Gain 1 mp.  Gain 1 Knowledge counter."
	name = "Prepare"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 0
