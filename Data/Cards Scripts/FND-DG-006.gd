extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Guard"
	description = "Clear all enemy positive effects. Apply Slow 1 to enemy."
	name = "Rinse"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
