extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Guard"
	description = "As an additional cost to play this card, discard any number of token cards from you hand. Gain Veil equal to 5 times that amount."
	name = "Throwaway Shield"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
