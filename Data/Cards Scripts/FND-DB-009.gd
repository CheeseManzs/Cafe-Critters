extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain Priority 1. "
	name = "Speed Up"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var prioStatus = Status.new(Status.EFFECTS.PRIORITY,1)
	attacker.addStatusCondition(prioStatus,true)
	return 0
