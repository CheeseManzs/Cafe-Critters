extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Deal (100% ATK) damage."
	name = "Strike"
	tags = ['Attack']
	rarity = RARITY.Common
	power = 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
