extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Inkhor"
	description = "15% Attack for each card in the opponent Fae's hand."
	name = "Counterweight Bash"
	power = 0.15

func effect(attacker: BattleMonster, defender: BattleMonster):
	for i in range(defender.currentHand.storedCards.size()):
		await dealDamage(attacker,defender)
