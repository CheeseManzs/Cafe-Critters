extends Card

func _init() -> void:
	cost = 6
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Rev"
	description = "Omen. Prevent the next instance of damage taken."
	name = "Dislocated"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
