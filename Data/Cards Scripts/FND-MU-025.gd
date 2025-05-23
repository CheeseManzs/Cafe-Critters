extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Inkhor"
	description = "125% Defend. Create 3 Jetsam in the opponent Fae's hand."
	name = "Inkcloud"
	shieldPower = 1.25

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	for i in range(2):
		defender.currentHand.storedCards.push_back(createInstance("Jetsam"))
