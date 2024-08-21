extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Empower the next card played."
	name = "Caffeinate"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#create status object
	var empStatus = Status.new(Status.EFFECTS.EMPOWER_PLAYED)
	#apply to target
	attacker.addStatusCondition(empStatus, false)
	return 0
