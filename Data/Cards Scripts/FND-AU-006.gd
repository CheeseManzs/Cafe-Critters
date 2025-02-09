extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Ignetor"
	description = "As an additional cost to play this card, consume 1 Heat. Prevent the next instance of damage this Fae would take. On your next turn, instead of taking an action, 60% Attack instead."
	name = "Land Dive"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
