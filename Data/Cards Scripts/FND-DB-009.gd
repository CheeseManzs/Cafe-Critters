extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain Priority 1. "
	name = "Speed Up"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	await giveStatus(attacker,Status.EFFECTS.PRIORITY,1)
	return 0

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	var prioLevel = 1
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		prioLevel = ceil(prioLevel*1.5)
	var prioStatus = Status.new(Status.EFFECTS.PRIORITY,prioLevel)
	return prioStatus
