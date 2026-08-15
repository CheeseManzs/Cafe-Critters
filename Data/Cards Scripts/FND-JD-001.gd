extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Discard a card at random, then draw 2."
	name = "Sleight of Hand"
	tags = ['Utility']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.discardRandomCard()
	await attacker.drawCards(2)
