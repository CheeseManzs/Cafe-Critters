extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "100% Defend."
	name = "Block"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var shield = attacker.getDefense()
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		shield = ceil(shield*1.5)
	attacker.addShield(shield)
	return shield

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	var shield = attacker.getDefense()
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		shield = ceil(shield*1.5)
	return shield
