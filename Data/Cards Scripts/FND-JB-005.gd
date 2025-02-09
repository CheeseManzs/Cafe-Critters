extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Basic"
	description = "Both players roll a d6 dice. The player with the higher number rolled draws 2 cards. If it's a tie, both players draw 2 cards."
	name = "Roll Off"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
