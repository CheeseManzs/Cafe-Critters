extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Guard"
	description = "125% Defense. Gain Regen 5."
	name = "Rejuvenate"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
