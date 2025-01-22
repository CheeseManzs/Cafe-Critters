extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Snake Eyes"
	description = "Discard any amount of cards, then roll that many d6 dice. (Total # rolled x 10%) Attack. If at least one 1 is rolled, gain 2 mp."
	name = "Rolldown"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
