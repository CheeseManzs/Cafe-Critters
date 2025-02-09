extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Mise
    role = "Point"
	description = "75% Defend. Mill 3."
	name = ""

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
