extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Roll 2 dice. Gain (8% DEF) block, multiplied by the roll value."
	name = "DIce Defend"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
