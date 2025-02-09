extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Ignetor"
	description = "20% Attack. Gain 1 Heat. Inflict 1 Burn."
	name = "Heat Pump"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
