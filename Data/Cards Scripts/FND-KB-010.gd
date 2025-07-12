extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Inflict Attack Down 1 and Defense Down 1. If you played 3+ skills last round, this skill goes first."
	name = "Screech"
	tags = ['Utility']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
