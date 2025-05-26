extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain (30% DEF) block. If Regenerating, draw 2."
	name = "Recalibrate"
	tags = ['Defence', ' Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
