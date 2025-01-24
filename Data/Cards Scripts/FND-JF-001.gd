extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Forward"
	description = "Roll a 6-sided die. On an even number, 125% Attack. On an odd number, 75% Attack."
	name = "Lucky Shot"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
