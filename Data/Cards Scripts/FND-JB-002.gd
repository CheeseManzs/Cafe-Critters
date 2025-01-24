extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Basic"
	description = "Draw 3 cards, then discard 3 cards at random."
	name = ""

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
