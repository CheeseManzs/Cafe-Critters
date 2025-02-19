extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Forward"
	description = "Omen. 10% Attack."
	name = "Hunter's Call"
	power = 0.1
	tags = ["Omen"]

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker,defender,power)
	await applyOmen(attacker, defender)
