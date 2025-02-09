extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Lil' Furnace"
	description = "If you've discarded Scrap this turn, create a Gold and gain 1 mp. 95% Attack"
	name = "Hot Blast"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
