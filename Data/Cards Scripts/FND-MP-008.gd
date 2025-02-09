extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Mise
    role = "Point"
	description = "Pitch: Until you switch out, deal 1 damage every time you banish a card."
	name = ""

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
