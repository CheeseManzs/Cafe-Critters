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

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
