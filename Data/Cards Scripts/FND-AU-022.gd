extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Lil' Furnace"
	description = "If you've discarded 5 or more Scrap this game, create 5 Gold in ally fae decks."
	name = "Vomit Ingots"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
