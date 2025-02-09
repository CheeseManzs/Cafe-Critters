extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Ignetor"
	description = "As an additional cost to play this card, discard a token card and consume 1 Heat. Attack 200%."
	name = "Hammer Head"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
