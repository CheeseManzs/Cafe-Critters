extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Junkguard"
	description = "Lose 20% of your HP. 200% Defend. Shuffle 2 Scrap into all ally fae decks."
	name = "Eroding Armor"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
