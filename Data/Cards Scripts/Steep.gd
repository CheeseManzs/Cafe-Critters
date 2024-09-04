extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Consume all Barrier. Gain Regen per Barrier consumed."
	name = "Steep"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#calc attack power
	var regenLevel = 0
	if attacker.hasStatus(Status.EFFECTS.BARRIER):
		var barStatus = attacker.getStatus(Status.EFFECTS.BARRIER)
		regenLevel += barStatus.X
		barStatus.X = 0
		barStatus.effectDone = true
	
	#draw cards
	attacker.addStatusCondition(Status.new(Status.EFFECTS.REGEN, regenLevel),true)
	return regenLevel
