extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Gain Focus 1 and (25% DEF) block. If you've played 3+ skills last turn, gain Focus 3 instead."
	name = "Lo-fi"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
