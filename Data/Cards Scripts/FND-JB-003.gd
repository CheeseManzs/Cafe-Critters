extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Search your deck for any card, add it to your hand. Then discard 3 cards at random."
	name = "Diabolical Odds"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
