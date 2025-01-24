extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Forward"
	description = "Roll two 6-sided die. Discard the lower number rolled amount of cards. (30% per higher number rolled) Attack."
	name = "Favoured Odds"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
