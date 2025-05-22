extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Mise
    role = "Basic"
	description = "The opposing Fae Mills 4."
	name = "Sinker"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
