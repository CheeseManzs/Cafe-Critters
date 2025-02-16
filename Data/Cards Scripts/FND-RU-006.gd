extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Smol"
	description = "Lose 25% of your max HP. Swap to another Fae, they 80% Defend."
	name = "Mist Step"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
