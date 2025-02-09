extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Mise
    role = "Point"
	description = "60% Attack. Salvage: 100% Attack, then exile this card."
	name = ""

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
