extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Mise
    role = "Point"
	description = "Draw 2. Salvage: Draw 2."
	name = ""

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
