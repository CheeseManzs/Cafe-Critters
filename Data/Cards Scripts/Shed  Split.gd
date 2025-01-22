extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Snake Eyes"
	description = "As an additional cost to play this card, discard a Dice card. Remove all negative effects, then swap to an ally Fae. Gain 1 Knowledge and 1 mp."
	name = "Shed & Split"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
