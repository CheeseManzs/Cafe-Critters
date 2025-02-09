extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Junkguard"
	description = "As an additional cost to play this card, discard 2 token cards. 1000% Defend. Swap to another fae, they gain Block equal to the amount Junkguard had before swapping. Then, execute Junkguard."
	name = "Built to Protect"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
