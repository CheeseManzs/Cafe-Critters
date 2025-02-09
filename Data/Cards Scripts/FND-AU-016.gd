extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Junkguard"
	description = "Discard your hand and lose all heat. Heal 10% of your HP per card discarded. (20% per heat consumed) Defend."
	name = "Power Down"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
