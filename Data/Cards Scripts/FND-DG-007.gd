extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Support
	description = "Clear all negative effects. Gain Regen 3."
	name = "Soothing Song"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#create status object
	for statusEffect in attacker.statusConditions:
		if !statusEffect.isPositive():
			statusEffect.effectDone = true
	BattleLog.log("All negative status effects cleared from " + attacker.rawData.name)
	#apply to target
	await giveStatus(attacker,Status.EFFECTS.REGEN, 3)
	return 0

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	var regStatus = Status.new(Status.EFFECTS.REGEN, 3)
	if attacker.hasStatus(Status.EFFECTS.EMPOWER_PLAYED):
		regStatus.X = ceil(regStatus.X*1.5)
	return regStatus
