extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Draw 3 cards, then discard 3 cards at random."
	name = "Card Replacement Therapy"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.drawCards(3)
	for i in range(3):
		await attacker.discardRandomCard()
	pass 
