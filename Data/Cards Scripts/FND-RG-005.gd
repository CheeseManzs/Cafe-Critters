extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
    role = "Guard"
	description = "Switch out opponent fae. Create a gold token."
	name = "Severance"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
