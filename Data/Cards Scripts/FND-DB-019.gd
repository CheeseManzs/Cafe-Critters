extends Card

func _init() -> void:
	cost = 3
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain (150% DEF) block. Gain Regen 15."
	name = "Rejuvenate"
	tags = ['Defence', ' Self-Target']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
