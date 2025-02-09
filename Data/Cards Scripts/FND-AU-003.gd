extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Ignetor"
	description = "As an additional cost to play this card, dicard any amount of token cards. Gain 1 Heat per card discarded. Gain Regen equal to the amount of Heat you have. Gain 1 mp."
	name = "Treatz"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
