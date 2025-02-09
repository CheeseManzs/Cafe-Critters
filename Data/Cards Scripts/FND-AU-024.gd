extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Lil' Furnace"
	description = "As an additional cost to play this card, discard any token card. All ally faes gain Defense Up 1. 45% Defend."
	name = "Refractory Lining"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
