extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Fold: Play me. Deal (75% ATK) damage."
	name = "Oops!"
	tags = ['Attack']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
