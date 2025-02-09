extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Mise
    role = "Point"
	description = "Pitch: Dredge 1/3."
	name = ""

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
