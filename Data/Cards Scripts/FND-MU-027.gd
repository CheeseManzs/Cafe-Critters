extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Inkhor"
	description = "65% Attack. Create 5 Flotsam in the opponent Fae's hand."
	name = "Turbulance"
	power = 0.65

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker,defender)
	for i in range(5):
		defender.currentHand.storedCards.push_back(createInstance("Flotsam"))
