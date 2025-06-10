extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Remove a random negative status."
	name = "Unburden"
	tags = ['Utility', 'Self-Target', 'Omen']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	await applyOmen(attacker, defender)
	
	var chosenStatusIndex = attacker.battleController.global_rng.randi_range(0, len(attacker.statusConditions) - 1)
	var statusList = []
	for status in attacker.statusConditions:
		if !status.isPositive() && !status.effectDone:
			statusList.push_back(status)
	
	if len(statusList) > 0:
		chosenStatusIndex = attacker.battleController.global_rng.randi_range(0, len(statusList) - 1)
		var chosenStatus = statusList[chosenStatusIndex]
		attacker.removeStatus(chosenStatus.effect)
	
	
