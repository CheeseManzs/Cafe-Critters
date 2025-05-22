extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Inkhor"
	description = "70% Defend. Create 12 Flotsam in your deck. Salvage: I cost 2 less. Dredge 2/2."
	name = "Abyssal Dive"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
