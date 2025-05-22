extends Card

func _init() -> void:
	cost = 6
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Inkhor"
	description = "Mill your entire deck. Heal 50% missing health."
	name = "Dead Reckoning"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
