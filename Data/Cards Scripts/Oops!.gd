extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Hooliquen"
	description = "Whenever you roll a 1 this turn, create 1 Dice in every ally fae deck."
	name = "Oops!"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
