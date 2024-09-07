extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Point
	description = "Apply Slow 2 to enemy."
	name = "Hinder"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#create status object
	var slowStatus = Status.new(Status.EFFECTS.SLOW, 2)
	#apply empower
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		slowStatus.X = ceil(slowStatus.X*1.5)
	#apply to target
	await defender.addStatusCondition(slowStatus, true)
	return 0

#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	#create status object
	var slowStatus = Status.new(Status.EFFECTS.SLOW, 2)
	#apply empower
	if attacker.hasStatus(Status.EFFECTS.EMPOWER_PLAYED):
		slowStatus.X = ceil(slowStatus.X*1.5)
	#apply to target
	return slowStatus
