extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Snake Eyes"
	description = "Whenever you roll a 1 this turn, create 1 Dice in every ally Fae deck. Gain 1 mp."
	name = "Insurance"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
