extends Card

func _init() -> void:
	cost = 0
	priority = 1
	alignment = ALIGNMENT.Mise
	role = "Inkhor"
	description = "20% Defend. Create 3 Jetsam in each active Fae's deck."
	name = "Jetspray"

	shieldPower = 0.2

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	for i in range(3):
		await attacker.shuffleCardIntoDeck(createInstance("Jetsam"), -1)
		await defender.shuffleCardIntoDeck(createInstance("Jetsam"), -1)
