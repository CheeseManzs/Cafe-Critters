extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Blackjack: Deal (100% ATK) damage. "
	name = "Face Card"
	tags = ['Attack']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
