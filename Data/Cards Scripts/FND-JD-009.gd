extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Blackjack: Gain (90% DEF) block. Deal (90% ATK) damage."
	name = "???"
	tags = ['Attack', 'Defence']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
