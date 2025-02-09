extends Card

func _init() -> void:
	cost = X
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Basic"
	description = "While in hand, this card becomes an exact copy of the last played dice card."
	name = "Double Down"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
