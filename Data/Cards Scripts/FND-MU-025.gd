extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Inkhor"
	description = "125% Defend. Create 3 Jetsam in the opponent Fae's hand."
	name = "Inkcloud"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
