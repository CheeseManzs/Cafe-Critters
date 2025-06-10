extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Heal (41% DEF) HP."
	name = "Scavenge"
	tags = ['Utility', 'Self-Target', 'Omen']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	await applyOmen(attacker, defender)
	var healed = attacker.getDefense()*0.41
	await attacker.addHP(healed)
	
