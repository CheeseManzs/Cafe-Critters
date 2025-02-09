extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Basic"
	description = "Defend 29%. Create a Scrap."
	name = "Cracked Shield"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
