extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Point"
	description = "Next round start, shuffle 3 Flotsam into your deck and Dredge 1/3."
	name = "Abyssal Call"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
