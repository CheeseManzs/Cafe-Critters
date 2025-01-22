extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Point"
	description = "The next time you would roll one or more dice, instead roll that many dice plus one and ignore the lowest roll."
	name = "Advantage"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
