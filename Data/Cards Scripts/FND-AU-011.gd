extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Junkguard"
	description = "As an additional cost to play this card, discard 2 token cards. 200% Defend. Shuffle a Scrap into all ally fae decks."
	name = "Armguards"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
