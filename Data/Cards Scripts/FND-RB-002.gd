extends Card

func _init() -> void:
	cost = 5
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Both players swap to a random Fae."
	name = "Panicked Streets"
	tags = ["Omen"]

func effect(attacker: BattleMonster, defender: BattleMonster):
	for mon in [attacker, defender]:
		await BattleCamera.singleton.focusMonsters(attacker.battleController.getTeam(mon))
		var newID = attacker.battleController.randomTeammateID(mon)
		if newID == -1:
			continue
		if mon.playerControlled:
			await attacker.battleController.playerSwap(newID)
		else:
			await defender.battleController.enemySwap(newID)
	await BattleCamera.singleton.disableFocus()
	await applyOmen(attacker, defender)
