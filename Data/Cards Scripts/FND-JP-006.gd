extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Point"
	description = "Roll a d6 dice, gain that much MP next turn."
	name = "MP Roulette"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
