extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Ignetor"
	description = "As an additional cost to play this card, discard a token card. Inflict 8 direct damage to the opponent Fae. Inflict 2 Burn"
	name = "Molten Bubble"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
