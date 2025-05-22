extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Mise
    role = "Basic"
	description = "Dredge 1/4. 60% Defend."
	name = "Line"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
