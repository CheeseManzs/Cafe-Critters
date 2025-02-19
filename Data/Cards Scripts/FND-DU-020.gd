extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Haatea"
	description = "Double your Regen, then gain barrier equal to your Regen."
	name = "Fanning Fortification"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
