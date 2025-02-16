extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Rea
    role = "Point"
	description = "Omen. Whenever a Fae becomes Tagged this round, they lose 10% of their max hp."
	name = "Fear of Missing Out"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
