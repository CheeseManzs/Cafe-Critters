extends Card

func _init() -> void:
	cost = 0
	priority = 1
	alignment = ALIGNMENT.Default
	role = ROLE.Support
	description = "Gain 1 mp. Gain Barrier 5."
	name = "Assist"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#idk what barrier is ngl but remember to apply empower to it
	var barrierGiven = 5
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		barrierGiven = ceil(barrierGiven*1.5)
	attacker.addStatusCondition(Status.new(Status.EFFECTS.BARRIER, barrierGiven), true)
	var mpGiven = 1
	#add mp
	attacker.addMP(mpGiven)
	return mpGiven

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	var shieldGiven = 5
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		shieldGiven = ceil(shieldGiven*1.5)
	return shieldGiven
