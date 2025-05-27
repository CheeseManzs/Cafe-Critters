extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Heal target shelved Fae for (35% DEF) HP"
	name = "Heal"
	tags = ['Utility', ' Self-Target']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	var chosenList = await attacker.battleController.chooseShelfedMon(1, attacker.playerControlled)
	var chosen: BattleMonster = attacker
	if len(chosenList) > 0:
		chosen = chosenList[0]
		
	var healed = attacker.getDefense()*0.35
	await chosen.addHP(healed)
	
	pass
