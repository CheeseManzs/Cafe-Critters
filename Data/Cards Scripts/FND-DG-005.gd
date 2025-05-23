extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Guard"
	description = "Heal target shelved critter for 5 HP."
	name = "Heal"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#get critters
	var targetCritters = await attacker.battleController.chooseShelfedMon(1, attacker.playerControlled)
	if len(targetCritters) > 0:
		var target = targetCritters[0]
		#add hp
		var hpGiven = 5
		if statusConditions.has(Status.EFFECTS.EMPOWER):
			hpGiven = ceil(hpGiven*1.5)
		await target.addHP(hpGiven)
	return 0
