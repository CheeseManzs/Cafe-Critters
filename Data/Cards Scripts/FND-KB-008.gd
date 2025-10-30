extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Gain (80% DEF) block. If you played 3+ skills last round, clear a negative status effect from self."
	name = "Frequency Isolation"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Common
	shieldPower = 0.8

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	if len(attacker.playedCardLastTurnHistory) >= 3:
		await attacker.removeStatus(attacker.getRandomStatus().effect)
	
