extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Gain Haste 1. Empowered: Gain Haste 3"
	name = "Cappucino"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#create status object
	var hasteLevel = 1
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		hasteLevel = 3
	var hasteStatus = Status.new(Status.EFFECTS.HASTE,hasteLevel)
	#apply to target
	attacker.addStatusCondition(hasteStatus, true)
	return 0
