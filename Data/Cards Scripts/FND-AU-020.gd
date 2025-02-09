extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Junkguard"
	description = "For the rest of the round, whenever Junkguard's Block is consumed, the opponent fae takes that much damage. "
	name = "Breaking Point"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
