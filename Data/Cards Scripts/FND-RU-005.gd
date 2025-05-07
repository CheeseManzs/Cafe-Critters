extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Rev"
	description = "If the opponent fae plays a card with Attack > 100%, nullify it. "
	name = "Headshot?"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
