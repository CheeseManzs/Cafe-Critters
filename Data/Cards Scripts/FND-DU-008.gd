extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Deal (10% ATK) damage for every stack of Focus and Fatigue. If this card is played with a modified cost, deal (20% ATK) damage instead."
	name = "Press"
	tags = ['Utility']
	rarity = RARITY.Rare
	power = 0.1

func effect(attacker: BattleMonster, defender: BattleMonster):
	var stacks = attacker.getStatusLevel(Status.EFFECTS.FATIGUE) + attacker.getStatusLevel(Status.EFFECTS.FOCUS)
	var fullPower = power*stacks
	if playedCost != cost:
		fullPower *= 2
	await dealDamage(attacker, defender, fullPower)

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var stacks = attacker.getStatusLevel(Status.EFFECTS.FATIGUE) + attacker.getStatusLevel(Status.EFFECTS.FOCUS)
	var fullPower = power*stacks
	if attacker.getCostMod() != 0:
		fullPower *= 2
	return _calcPower(attacker, defender, fullPower)
