extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "50% Defend."
	name = "Minor Block"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 0
