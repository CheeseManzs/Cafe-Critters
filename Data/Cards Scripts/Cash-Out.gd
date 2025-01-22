extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Snake Eyes"
	description = "Discard any amount of Dice, roll that many d6 dice, then gain that much Regen."
	name = "Cash-Out"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
