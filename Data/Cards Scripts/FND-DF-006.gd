extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
    role = "Forward"
	description = "When Endless Blows is played, shuffle 3 "Endless Blows" into your deck. (50% + 10% per Endless Blows played) Attack"
	name = "Endless Blows"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
