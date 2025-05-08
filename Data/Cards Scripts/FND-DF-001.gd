extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain 1 mp. 20% Attack."
	name = "Warm Up"
	
	power = 0.2

func effect(attacker: BattleMonster, defender: BattleMonster):
	#add mp
	attacker.addMP(1)
	#calc attack power
	await dealDamage(attacker, defender)
