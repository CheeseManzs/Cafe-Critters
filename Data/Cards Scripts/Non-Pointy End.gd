extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Hooliquen"
	description = "Reckless: > 100% Attack. If Reckless, draw a card. 125% Attack"
	name = "Non-Pointy End"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
