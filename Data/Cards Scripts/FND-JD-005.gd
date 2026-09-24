extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "When you discard a card this turn, deal (10% ATK) damage. Gain 1 AP."
	name = "Stack Your Chips"
	tags = ['Attack']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(attacker, Status_Stack_Your_Chips.new())
	pass
