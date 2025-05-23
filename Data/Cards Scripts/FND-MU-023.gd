extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Inkhor"
	description = "30% Attack. Create 8 Jetsam in the opponent Fae's deck."
	name = "Throw Overboard"
	power = 0.3

func effect(attacker: BattleMonster, defender: BattleMonster):
	
	await dealDamage(attacker,defender)
	for i in range(8):
		await defender.shuffleCardIntoDeck(createInstance("Jetsam"), -1)
