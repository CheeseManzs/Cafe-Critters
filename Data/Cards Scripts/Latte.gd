extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Apply Slow 1 to enemy. Empowered: Apply Slow 3 to enemy."
	name = "Latte"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#create status object
	var slowLevel = 1
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		slowLevel = 3
	var slowStatus = Status.new(Status.EFFECTS.SLOW,slowLevel)
	#apply to target
	defender.addStatusCondition(slowStatus, true)
	return 0
