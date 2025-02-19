extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen."
	name = "Toll the Bells"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
