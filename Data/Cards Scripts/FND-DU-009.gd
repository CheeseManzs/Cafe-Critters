extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "As an additional cost to play this card, exile 12 cards. Gain Focus 5."
	name = "Brew"
	tags = ['Utility']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
