extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "This turn, when your faes' Attacks are blocked, deal (15% DEF) unblockable damage."
	name = "Insurance"
	tags = ['Utility', ' Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
