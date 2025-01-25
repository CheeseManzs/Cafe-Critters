extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "40% Attack, Empowered: Empower the next card played."
	name = "Espresso"
	power = 0.4

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#create status object
	await dealDamage(attacker, defender, power, false)
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		await attacker.addStatusCondition(Status.new(Status.EFFECTS.EMPOWER_PLAYED))
	
	return 0

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	if attacker.hasStatus(Status.EFFECTS.EMPOWER_PLAYED):
		return Status.new(Status.EFFECTS.EMPOWER_PLAYED)
	return null
