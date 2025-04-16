extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Ignetor"
	description = "You may only play this card if this fae has 4 or more Heat. Attack 85%. Inflict 5 Burn. "
	name = "Combustfang"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
