extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Smol"
	description = "Store all negative effects applied to Smol or it's team this turn. If Smol has not swapped out by the start of the next turn, apply them to the opponent instead. Otherwise, apply them to yourself."
	name = "Skull Breath"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
