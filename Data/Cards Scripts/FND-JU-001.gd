extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = ROLE.Unique
	description = "Reckless. 125% Attack."
	name = "Savage Stab"
	
	power = 1.25

func effect(attacker: BattleMonster, defender: BattleMonster):
	#calc attack power
	await applyReckless(attacker, defender)
	await dealDamage(attacker, defender)
