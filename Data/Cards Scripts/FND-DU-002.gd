extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Apply Slow 1 to enemy. Empowered: Apply Slow 3 to enemy."
	name = "Latte"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#create status object
	var slowLevel = 1
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		slowLevel = 3
	#apply to target
	await giveStatus_noempower(defender,Status.EFFECTS.SLOW,slowLevel)
	return 0

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null

#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	var slowLevel = 1
	if attacker.hasStatus(Status.EFFECTS.EMPOWER_PLAYED):
		slowLevel = 3
	var slowStatus = Status.new(Status.EFFECTS.SLOW,slowLevel)
	return slowStatus
