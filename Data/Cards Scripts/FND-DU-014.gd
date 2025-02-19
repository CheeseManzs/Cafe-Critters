extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Haatea"
	description = "Gain Barrier 10. Gain Regen 2."
	name = "Lemon-Aid"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(attacker,Status.EFFECTS.BARRIER,10)
	await giveStatus(attacker,Status.EFFECTS.REGEN,2)

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	var lv = 10
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		lv = 15
	return Status.new(Status.EFFECTS.BARRIER, lv)
