extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Mise
    role = "Point"
	description = "Next round start: inflict Riptide 3 to all active Faes."
	name = "Choppy Seas Ahead"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
