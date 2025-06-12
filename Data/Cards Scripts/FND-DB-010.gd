extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Swap to another Fae, they deal (45% ATK) damage."
	name = "Sneak Attack"
	tags = ['Attack']
	rarity = RARITY.Rare
	power = 0.45

func effect(attacker: BattleMonster, defender: BattleMonster):
	if attacker.playerControlled:
		await attacker.battleController.promptPlayerSwitch()
	else:
		await attacker.battleController.promptEnemySwitch()
	
	await dealDamage(attacker.getActiveTeammate(), defender, power)
		
