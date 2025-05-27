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
	var chosen = await attacker.battleController.chooseShelfedMon(1, attacker.playerControlled)
	if len(chosen) > 0:
		var switchTarget: BattleMonster = chosen[0]
		await dealDamage(switchTarget, defender, power)
	else:
		await dealDamage(attacker, defender, power)
		
