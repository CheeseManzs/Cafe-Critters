extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "100% Attack."
	name = "Strike"
	
	power = 1



	
func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
