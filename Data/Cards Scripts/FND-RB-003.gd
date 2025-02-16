extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Rea
    role = "Basic"
	description = "Search your deck for any Omen card. Put it in the graveyard."
	name = "Raven Sighting"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
