extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Ignetor"
	description = "You may only play this card if the opponent fae has 50% HP or less. 50% Attack, then inflict 1 Burn. Repeat this as long as you have Heat. Gain 1 mp."
	name = "Mechanical Ravage"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
