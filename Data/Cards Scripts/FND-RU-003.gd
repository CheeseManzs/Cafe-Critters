extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Smol"
	description = "If you've taken no damage this turn, gain Knowledge 3 and 3 mp."
	name = "Prep Time"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
