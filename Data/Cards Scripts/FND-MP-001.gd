extends Card

func _init() -> void:
	cost = 
	priority = 0
	alignment = ALIGNMENT.Mise
    role = "Point"
	description = ""
	name = ""

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
