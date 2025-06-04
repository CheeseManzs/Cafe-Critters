extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks [Aggro]
	role = "Basic"
	description = "Deal (95% ATK) damage. If the last card you played was an Attack, gain 1 MP."
	name = "Streak"
	tags = ['Attack']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
