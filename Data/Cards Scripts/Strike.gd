extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "100% Attack."
	name = "Strike"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 0
