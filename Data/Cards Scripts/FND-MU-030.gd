extends Card

func _init() -> void:
	cost = 6
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Inkhor"
	description = "Mill your entire deck. Heal 50% missing health."
	name = "Dead Reckoning"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.millCards(attacker.currentDeck.storedCards.size())
	var missingHP: int = attacker.maxHP - attacker.health
	await attacker.addHP(missingHP/2)
