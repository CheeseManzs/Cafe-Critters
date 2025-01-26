extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Forward"
	description = "40% Attack. Then do a 30% Attack to all opponent shelved Faes."
	name = "Cleave"
	power = 0.4

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	for mon in defender.battleController.getTeam(defender):
		if mon != defender and !mon.isKO():
			await attacker.battleController.get_tree().create_timer(1).timeout
			await dealDamage(attacker,mon,0.3)
