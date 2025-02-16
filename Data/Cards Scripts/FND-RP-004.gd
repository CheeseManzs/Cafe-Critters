extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Rea
    role = "Point"
	description = "Omen. Whenever a Fae becomes Tagged this turn, inflict Poison 5."
	name = "Fear of Inaction"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
