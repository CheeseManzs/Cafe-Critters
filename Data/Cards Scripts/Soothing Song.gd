extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Support
	description = "Clear all negative effects. Gain Regen 3."
	name = "Soothing Song"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#create status object
	var regStatus = Status.new(Status.EFFECTS.REGEN, 3)
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		regStatus.X = ceil(regStatus.X*1.5)
	#apply to target
	attacker.addStatusCondition(regStatus, true)
	return 0
