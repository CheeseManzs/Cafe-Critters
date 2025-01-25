extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Swap to another Fae, they make a 65% Attack."
	name = "Sneak Attack"
	
	power = 0.65

func effect(attacker: BattleMonster, defender: BattleMonster):
	var switchedIn: BattleMonster
	if attacker.playerControlled:
		await attacker.battleController.promptPlayerSwitch()
		switchedIn = attacker.battleController.getActivePlayerMon()
	else:
		await attacker.battleController.promptEnemySwitch()
		switchedIn = attacker.battleController.getActiveEnemyMon()
	
	await dealDamage(switchedIn, defender)
