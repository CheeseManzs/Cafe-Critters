extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Lil' Furnace"
	description = "Discard any number of token cards. Then, create that many Scrap in all ally fae decks and draw that many cards."
	name = "The Cycle"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
