extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Deal (40% ATK) damage."
	name = "Wight Grasp"
	tags = ['Attack', 'Omen']
	rarity = RARITY.Common
	power = 0.4

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	await applyOmen(attacker, defender)
