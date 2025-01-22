extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Point"
	description = "Roll a d6 die, 1-3: draw a card, 4-6: draw a card, then draw another one next turn. "
	name = "Investment "

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
