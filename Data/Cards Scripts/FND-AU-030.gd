extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Lil' Furnace"
	description = "For the rest of the game, whenever Lil' Furnace draws a Scrap card, draw another card. "
	name = "Scrap Hunter"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
