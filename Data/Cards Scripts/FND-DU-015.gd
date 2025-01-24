extends Card

func _init() -> void:
	cost = X
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Haatea"
	description = "Consume all mp. (10% per mp consumed) Attack. Gain 1 Regen per mp consumed. "
	name = "Trunk Shot"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
