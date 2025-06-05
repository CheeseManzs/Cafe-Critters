extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Draw 2. If neither of those cards were Attacks, discard your hand."
	name = "Power Gamble"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	var drawnCards = await attacker.drawCards(2)
	var drewAttack = false
	for card in drawnCards:
		if "Attack" in card.tags:
			drewAttack = true
	if !drewAttack:
		await attacker.discardHand()
