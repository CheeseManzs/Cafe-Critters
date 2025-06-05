extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Deal (95% ATK) damage. If the last card you played was an Attack, gain 1 MP."
	name = "Streak"
	tags = ['Attack']
	rarity = RARITY.Rare
	power = 0.95

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	if len(attacker.playedCardHistory) > 0 && "Attack" in attacker.playedCardHistory[len(attacker.playedCardHistory) - 1].tags:
		await attacker.addMP(1)
