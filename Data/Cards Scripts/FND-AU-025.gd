extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Lil' Furnace"
	description = "Create 2 Scrap. Clear the next positive effect Lil' Furnace gains."
	name = "Stack Skimming"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
