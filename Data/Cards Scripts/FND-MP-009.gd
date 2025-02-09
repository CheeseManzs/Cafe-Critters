extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Mise
    role = "Point"
	description = "50% Attack. Salvage: Permanently increase the damage of this card by 50%."
	name = ""

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
