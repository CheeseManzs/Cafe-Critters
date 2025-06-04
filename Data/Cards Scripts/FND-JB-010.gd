extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks [Aggro]
	role = "Basic"
	description = "Inflict Fear 5. Deal (5% ATK) damage."
	name = "Freaky Shiv"
	tags = ['Attack']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
