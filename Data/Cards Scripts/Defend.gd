extends Card

func _init() -> void:
	cost = 0
	priority = 1
	alignment = ALIGNMENT.Default
	role = ROLE.Support
	description = "Gain temporary shield equal to your Defense stat"
	name = "Defend"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var shield = attacker.defense
	attacker.addShield(shield)
	return shield
