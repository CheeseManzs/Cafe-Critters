extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Guard"
	description = "Omen. Gain Veil 1."
	name = "Mourning Widow"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
