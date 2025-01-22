extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
    role = "Hooliquen"
	description = "Your next attack gains +25%. Strongarm. Gain 1 mp."
	name = "You're In For It Now"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
