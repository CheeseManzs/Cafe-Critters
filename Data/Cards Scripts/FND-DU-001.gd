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
	await attacker.addStatusCondition(hasteStatus, true)
	return 0

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	var hasteLevel = 1
	if attacker.hasStatus(Status.EFFECTS.EMPOWER_PLAYED):
		hasteLevel = 3
	var hasteStatus = Status.new(Status.EFFECTS.HASTE,hasteLevel)
	return hasteStatus

#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null
