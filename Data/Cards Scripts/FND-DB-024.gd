extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain (75% DEF) block. If this fae swapped in this turn, gain (150% DEF) block instead."
	name = "Tanking"
	tags = ['Defence', ' Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
