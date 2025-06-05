extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Deal (45% ATK) damage. If this Attack hits, shuffle it into your deck and draw 1."
	name = "Steel Shuffler"
	tags = ['Attack']
	rarity = RARITY.Uncommon
	power = 0.45

func effect(attacker: BattleMonster, defender: BattleMonster):
	var pureDmg = await dealDamage(attacker, defender)
	if pureDmg > 0:
		await attacker.currentDeck.storedCards.push_back(self)
		await attacker.drawCards(1)
