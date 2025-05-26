extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain Focus 1. If Focused, gain Focus 3 instead. "
	name = "Bolster"
	tags = ['Utility', ' Self-Target']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
