extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Gain (70% DEF) block. If your opponent Attacks this action, deal (70% ATK) damage."
	name = "Better Not"
	tags = ['Defence', ' Self-Target']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
