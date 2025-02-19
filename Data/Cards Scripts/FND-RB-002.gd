extends Card

func _init() -> void:
	cost = 5
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Both players swap to a random Fae."
	name = "Panicked Streets"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
