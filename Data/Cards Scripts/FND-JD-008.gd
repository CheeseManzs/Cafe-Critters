extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Draw 2 cards, then put a card on top of your deck."
	name = "Stack Deck"
	tags = ['Utility']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
