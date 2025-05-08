extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Haatea"
	description = "Consume all Barrier. Gain Regen per Barrier consumed."
	name = "Steep"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#calc attack power
	var regenLevel = 0
	if attacker.hasStatus(Status.EFFECTS.BARRIER):
		var barStatus = attacker.getStatus(Status.EFFECTS.BARRIER)
		regenLevel += barStatus.X
		barStatus.X = 0
		barStatus.effectDone = true
	
	await giveStatus(attacker, Status.EFFECTS.REGEN, regenLevel)
	return regenLevel

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	var regenLevel = 0
	if attacker.hasStatus(Status.EFFECTS.BARRIER):
		var barStatus = attacker.getStatus(Status.EFFECTS.BARRIER)
		regenLevel += barStatus.X
	#draw cards
	return Status.new(Status.EFFECTS.REGEN, regenLevel)

func calcStatusCured(attacker: BattleMonster, defender: BattleMonster) -> Status.EFFECTS:
	return Status.EFFECTS.BARRIER
