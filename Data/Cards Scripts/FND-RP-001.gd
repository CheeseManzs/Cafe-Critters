extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Point"
	description = "Omen. Shuffle a gold token in your deck."
	name = "Invest"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
