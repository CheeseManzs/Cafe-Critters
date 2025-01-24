extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Snake Eyes"
	description = "Reckless: Dice. If Reckless, Inflict 5 Poison. (10% + 20% per opponent poison stack) Attack."
	name = "Rollout Roulette"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
