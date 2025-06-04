extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Roll a die. Deal (60% ATK) damage. If you rolled a 1 or 2, take (20% ATK) damage. If you rolled a 6, your opponent discards 1 at random, then draws 1."
	name = "Reckless Swing"
	tags = ['Attack']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
