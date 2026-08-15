extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Blackjack: Gain (150% DEF) block and put me in your hand. Put this card third from the top of your deck."
	name = "Card Count"
	tags = ['Defence']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
