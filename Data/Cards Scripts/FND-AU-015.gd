extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Junkguard"
	description = "20% Defend. If Tagged, next round, if your active fae is not a Machine, heal them equal to the amount of Block discarded this round."
	name = "Friend"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
