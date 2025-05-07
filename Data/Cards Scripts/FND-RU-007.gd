extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Rev"
	description = "If Tagged and your opponent plays an offensive card this turn, give this card Omen for the rest of the game. 25% Attack. Strongarm."
	name = "Backshots"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
