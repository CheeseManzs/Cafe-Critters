extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Deal (30% ATK) damage. Draw 1."
	name = "Note of Dissonance"
	tags = ['Attack']
	rarity = RARITY.Common
	power = 0.3

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	await attacker.drawCards(1)
