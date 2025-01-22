extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Snake Eyes"
	description = "Roll 5 d6 dice. For every 1 rolled, inflict 3 Poison to opponent fae, 1-4: (10 x number rolled)% Attack, 5: 50% Defend, 6: create 1 Dice in every ally fae deck."
	name = "Slither Storm"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
