extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Mise
    role = "Point"
	description = "90% Defend. Salvage: 100% Attack and Mill 2 instead."
	name = ""

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
