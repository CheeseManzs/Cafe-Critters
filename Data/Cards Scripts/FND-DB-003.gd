extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "50% Attack."
	name = "Light Strike"
	
	power = 0.5

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
