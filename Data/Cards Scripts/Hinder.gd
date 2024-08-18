extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Point
	description = "Apply Slow 2 to enemy."
	name = "Hinder"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#create status object
	var slowStatus = Status.new(Status.EFFECTS.SLOW, 2)
	#apply empower
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		slowStatus.X *= 1.5
	#apply to target
	defender.addStatusCondition(slowStatus, true)
	return 0
