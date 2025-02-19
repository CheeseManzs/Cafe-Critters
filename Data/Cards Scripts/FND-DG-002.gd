extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Guard"
	description = "Gain 1 mp. Gain Regen 3."
	name = "Prime"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var mpGiven = 1
	#add mp
	await attacker.addMP(mpGiven)
	await giveStatus(attacker,Status.EFFECTS.REGEN, 3)
	return mpGiven



#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	var barrierGiven = 3
	if attacker.hasStatus(Status.EFFECTS.EMPOWER_PLAYED):
		barrierGiven = ceil(barrierGiven*1.5)
	return Status.new(Status.EFFECTS.REGEN, barrierGiven)
