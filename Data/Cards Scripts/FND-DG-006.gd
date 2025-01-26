extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Guard"
	description = "Clear all enemy positive effects. Apply Slow 1 to enemy."
	name = "Rinse"

func effect(attacker: BattleMonster, defender: BattleMonster):
	for statusEffect in defender.statusConditions:
		if statusEffect.isPositive():
			statusEffect.effectDone = true
	BattleLog.singleton.log("All positive effects cleared from " + defender.rawData.name)
	await giveStatus(defender, Status.EFFECTS.SLOW,1)
