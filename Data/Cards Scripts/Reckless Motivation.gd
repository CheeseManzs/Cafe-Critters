extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Set your Attack to 0. Empower the next card played."
	name = "Reckless Motivation"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 0
