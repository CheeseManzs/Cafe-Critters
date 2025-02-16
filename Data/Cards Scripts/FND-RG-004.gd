extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
    role = "Guard"
	description = "As an additional cost to play this card, shuffle an Omen card back into it's respective Fae's deck. Gain Veil 30."
	name = "Blessing in Disguise"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
