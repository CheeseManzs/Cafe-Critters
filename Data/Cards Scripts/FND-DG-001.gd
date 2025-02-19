extends Card

func _init() -> void:
	cost = 0
	priority = 1
	alignment = ALIGNMENT.Default
	role = ROLE.Support
	description = "Gain 1 mp. Gain Barrier 3."
	name = "Steady"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#idk what barrier is ngl but remember to apply empower to it
	var mpGiven = 1
	#add mp
	await attacker.addMP(mpGiven)
	await giveStatus(attacker,Status.EFFECTS.BARRIER, 3)
	return mpGiven



#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	var barrierGiven = 3
	if attacker.hasStatus(Status.EFFECTS.EMPOWER_PLAYED):
		barrierGiven = ceil(barrierGiven*1.5)
	return Status.new(Status.EFFECTS.BARRIER, barrierGiven)
