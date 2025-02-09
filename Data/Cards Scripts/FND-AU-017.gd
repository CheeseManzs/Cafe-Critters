extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Junkguard"
	description = "As an additional cost to play this card, discard 2 token cards. Nullify the card the opponent plays this turn. 100% Attack."
	name = "01101110 01101111"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
