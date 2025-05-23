extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Inkhor"
	description = "75% Defend. Create 2 Flotsam in each active Fae's hand. Salvage: 120% Defend."
	name = "Mooring"
	shieldPower = 0.75

func effect(attacker: BattleMonster, defender: BattleMonster):
	if !salvaged:
		selfTarget = false
		await giveShield(attacker, defender)
		for i in range(2):
			defender.currentHand.storedCards.push_back(createInstance("Flotsam"))
			attacker.currentHand.storedCards.push_back(createInstance("Flotsam"))
	else:
		selfTarget = true
		await giveShield(attacker, defender, 1.2)
