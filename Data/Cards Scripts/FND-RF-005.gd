extends Card

func _init() -> void:
	cost = 4
	priority = 0
	alignment = ALIGNMENT.Rea
    role = "Forward"
	description = "Omen. Opponent Fae discards a card."
	name = "Relentless Thoughts"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
