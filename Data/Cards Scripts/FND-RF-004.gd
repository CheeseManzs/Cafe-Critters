extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
    role = "Forward"
	description = "Omen. 10% Attack."
	name = "Hunter's Call"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
