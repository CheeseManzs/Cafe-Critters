extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Guard"
	description = "Omen. Gain Regen 1."
	name = "Confession"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
