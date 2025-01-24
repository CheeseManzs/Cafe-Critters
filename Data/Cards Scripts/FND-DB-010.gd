extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Swap to another Fae, they make a 65% Attack."
	name = "Sneak Attack"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var switchedIn: BattleMonster
	if attacker.playerControlled:
		await attacker.battleController.promptPlayerSwitch()
		switchedIn = attacker.battleController.getActivePlayerMon()
	else:
		await attacker.battleController.promptEnemySwitch()
		switchedIn = attacker.battleController.getActiveEnemyMon()
	
	var dmg = ceil(switchedIn.getAttack()*0.65)
	defender.receiveDamage(dmg,switchedIn)
	return dmg

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	return ceil(attacker.getAttack()*0.65)
