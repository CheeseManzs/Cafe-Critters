extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Snake Eyes"
	description = "Create 3 Dice in every ally fae deck. "
	name = "Ready to Roll"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
