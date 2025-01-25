extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Guard"
	description = "Gain 1 mp. Gain Regen 3."
	name = "Prime"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#idk what barrier is ngl but remember to apply empower to it
	var barrierGiven = 3
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		barrierGiven = ceil(barrierGiven*1.5)
	await attacker.addStatusCondition(Status.new(Status.EFFECTS.REGEN, barrierGiven), true)
	var mpGiven = 1
	#add mp
	attacker.addMP(mpGiven)
	return mpGiven



#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	var barrierGiven = 3
	if attacker.hasStatus(Status.EFFECTS.EMPOWER_PLAYED):
		barrierGiven = ceil(barrierGiven*1.5)
	return Status.new(Status.EFFECTS.REGEN, barrierGiven)
