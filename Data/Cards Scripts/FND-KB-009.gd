extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Gain (30% DEF) block. If you played 3+ skills last round, heal (30% DEF) health. If you played 5+ skills last round, draw 1."
	name = "Meditative Melody"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Common
	shieldPower = 0.3

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	
	if len(attacker.playedCardLastTurnHistory) >= 3:
		var hpGiven = attacker.getDefense()*shieldPower
		await attacker.addHP(hpGiven)
	
	if len(attacker.playedCardLastTurnHistory) >= 5:
		await attacker.drawCards(1)
