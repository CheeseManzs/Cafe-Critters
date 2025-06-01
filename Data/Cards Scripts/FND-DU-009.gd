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

func canBePlayed(user: BattleMonster):
	return len(user.currentDeck.storedCards) >= 12

func effect(attacker: BattleMonster, defender: BattleMonster):
	for i in 12:
		await attacker.exileRandomCard()
	await giveStatus(attacker, Status.EFFECTS.FOCUS, 5)
