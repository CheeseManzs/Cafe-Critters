extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Lil' Furnace"
	description = "As an additional cost to play this card, discard any token card. All opponent faes gain Defense Down 2. "
	name = "Reverbratory Furnace"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
