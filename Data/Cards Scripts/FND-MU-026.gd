extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Inkhor"
	description = "Inflict Riptide 1. Create 6 Flotsam in each active Fae's deck. Draw 1."
	name = "Uncontrolled Discharge"

	
func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(defender,Status.EFFECTS.RIPTIDE,1)
	for i in range(6):
		await attacker.shuffleCardIntoDeck(createInstance("Flotsam"), -1)
		await defender.shuffleCardIntoDeck(createInstance("Flotsam"), -1)
	await attacker.drawCards(1)
