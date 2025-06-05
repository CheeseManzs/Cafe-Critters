extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Deal (75% ATK) damage. If this Attack hits, the target loses half of their positive statuses."
	name = "Stack Breaker"
	tags = ['Attack']
	rarity = RARITY.Uncommon
	power = 0.75

func effect(attacker: BattleMonster, defender: BattleMonster):
	var pureDmg = await dealDamage(attacker, defender)
	if pureDmg > 0:
		for status in defender.statusConditions:
			if !status.effectDone && status.isPositive() && status.X > 0:
				var oldStacks = status.X
				status.addX(-int(status.X/2))
				var change =  oldStacks - status.X
				BattleLog.log(defender.getName() + " lost " + str(change) + " stacks of " + status.rawToString())
