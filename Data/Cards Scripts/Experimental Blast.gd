extends Card

func _init() -> void:
	cost = 4
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Forward"
	description = "Reckless. Reckless. Reckless. 300% Attack. "
	name = "Experimental Blast"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
