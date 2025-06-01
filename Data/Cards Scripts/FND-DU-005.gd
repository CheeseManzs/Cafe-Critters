extends Card

func _init() -> void:
	cost = 4
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Gain (160% DEF) block. Apply Fatigue 1 to opponent. If this card is played with a modified cost, opposing fae discards 2 and draws that many."
	name = "Affogato"
	tags = ['Defence']
	rarity = RARITY.Uncommon
	shieldPower = 1.6

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	await giveStatus(defender, Status.EFFECTS.FATIGUE, 1)
	if playedCost != cost:
		for i in 2:
			await defender.discardRandomCard()
		await defender.drawCards(2)
	return

func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster):
	return Status.new(Status.EFFECTS.FATIGUE, 1)
