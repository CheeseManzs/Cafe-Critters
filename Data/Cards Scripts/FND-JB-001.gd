extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks [Aggro]
	role = "Basic"
	description = "Roll a die. Deal (90% ATK) damage. If you rolled a 4, 5, or 6, deal (125% ATK) damage instead."
	name = "Lucky Shot"
	tags = ['Attack']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
