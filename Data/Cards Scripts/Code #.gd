extends Card

func _init() -> void:
	cost = Cost
	priority = 0
	alignment = ALIGNMENT.God
    role = "Role"
	description = "Card Description"
	name = "Name"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
