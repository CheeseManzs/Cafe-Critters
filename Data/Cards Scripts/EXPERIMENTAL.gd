extends Card

func _init() -> void:
	cost = 9
	priority = 0
	alignment = ALIGNMENT.Default
    role = "Basic"
	description = "Execute the opponent Fae."
	name = "So Long Gay Bowser"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
