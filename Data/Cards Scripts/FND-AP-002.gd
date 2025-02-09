extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Point"
	description = "Create 10 Scrap in all ally fae decks."
	name = "Junkyard Deal"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
