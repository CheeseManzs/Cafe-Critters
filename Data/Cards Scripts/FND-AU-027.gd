extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Lil' Furnace"
	description = "This card may only be played if it's the first card played this turn. You may no longer swithc out this turn. If an ally were to gain Attack Up or Defese Up, they gain that much +1 instead. "
	name = "Preheating"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
