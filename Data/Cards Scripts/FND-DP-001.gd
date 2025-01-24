extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Point
	description = "Gain 1 mp.  Gain 1 Knowledge counter."
	name = "Prepare"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var mpGiven = 1
	var knowledgeGiven = 1
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		knowledgeGiven = ceil(knowledgeGiven*1.5)
	#add mp
	attacker.addMP(mpGiven)
	#add knowledge counter
	attacker.addCounter(Status.EFFECTS.KNOWLEDGE,knowledgeGiven)
	return 0
