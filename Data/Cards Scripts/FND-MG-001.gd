extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Guard"
	description = "Mill 2. Your opponent Mills 2."
	name = ""

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
