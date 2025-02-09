extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Guard"
	description = "If you've discarded 5 or more Scrap this game, gain Defense Up 4."
	name = "Lost Shield Blueprint"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
