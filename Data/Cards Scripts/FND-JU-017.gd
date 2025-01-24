extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Snake Eyes"
	description = "Discard any amount of token cards, roll that many d6 dice, then gain Knowledge equal to the number rolled."
	name = "Cash-Out"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
