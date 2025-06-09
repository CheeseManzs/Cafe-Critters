extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "If this fae has not played a card this turn, draw 3, then discard all non-Attacks."
	name = "All-In"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	if !defender.playedCardThisTurn:
		await attacker.drawCards(3)
		await attacker.discardHand(CardFilter.new([],["Attack"]))
	
