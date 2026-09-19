extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Discard a random card. Deal (125% ATK) damage"
	name = "Reckless Swing"
	tags = ['Attack']
	rarity = RARITY.Uncommon
	power = 1.25

func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.discardRandomCard()
	await dealDamage(attacker, defender)
