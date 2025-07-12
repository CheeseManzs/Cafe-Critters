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

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
