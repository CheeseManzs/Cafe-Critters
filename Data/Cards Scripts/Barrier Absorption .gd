extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
    role = "Haatea"
	description = "Consume all Barrier. Gain Regen per Barrier consumed. "
	name = "Barrier Absorption "

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
