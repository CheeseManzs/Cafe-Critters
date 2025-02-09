extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Forward"
	description = "Roll a d6. Attack 10% per number rolled. Repeat this 6 times."
	name = "Dice's Fury"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
