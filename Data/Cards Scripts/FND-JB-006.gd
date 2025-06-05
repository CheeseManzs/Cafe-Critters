extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Draw an Attack, then discard 1 at random."
	name = "Adrenaline Addiction"
	tags = ['Attack']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.drawCards(1, CardFilter.new(["Attack"]))
	await attacker.discardRandomCard()
