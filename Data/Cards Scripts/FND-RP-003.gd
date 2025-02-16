extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Rea
    role = "Point"
	description = "Omen. Take 2 damage. Gain Knowledge 1. "
	name = "Burden of Knowledge"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
