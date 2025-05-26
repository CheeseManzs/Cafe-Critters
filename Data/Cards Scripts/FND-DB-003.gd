extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Deal (50% ATK) damage."
	name = "Light Strike"
	tags = ['Attack']
	rarity = RARITY.Common
	power = 0.5

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
