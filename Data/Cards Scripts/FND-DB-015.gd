extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Deal (35% ATK) damage."
	name = "Quick Strike"
	tags = ['Attack']
	rarity = RARITY.Uncommon
	power = 0.35

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
