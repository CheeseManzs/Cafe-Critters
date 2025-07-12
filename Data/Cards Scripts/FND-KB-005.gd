extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Deal (70% ATK) damage. If you played 3+ skills last round, deal (50% ATK) more damage."
	name = "High Note"
	tags = ['Attack']
	rarity = RARITY.Common
	power = 0.7

func effect(attacker: BattleMonster, defender: BattleMonster):
	var extraPower = 0
	if len(attacker.playedCardCurrentTurnHistory) >= 3:
		extraPower = 0.5
	await dealDamage(attacker, defender, power + extraPower)
	
		
