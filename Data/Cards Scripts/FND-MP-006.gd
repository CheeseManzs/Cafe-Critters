extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Mise
    role = "Point"
	description = "Inflict 1 Riptide. Mill 3."
	name = ""

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
