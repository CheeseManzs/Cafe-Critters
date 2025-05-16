extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Forward"
	description = "Priority. 30% Attack."
	name = "Quick Strike"
	power = 0.3

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
