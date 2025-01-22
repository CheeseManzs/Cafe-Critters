extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
    role = "Slocha"
	description = "50% Defend. If Hasted, Empower the next card played. If enemy is Slowed, 100% Defend instead."
	name = "Turtle Time"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
