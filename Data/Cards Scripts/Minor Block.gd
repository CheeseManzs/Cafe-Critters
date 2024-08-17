extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "50% Defend."
	name = "Minor Block"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var shield = ceil(attacker.defense/2.0)
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		shield = ceil(shield*1.5)
	attacker.addShield(shield)
	return shield
