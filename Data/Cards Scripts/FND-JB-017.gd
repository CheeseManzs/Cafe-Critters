extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks [Aggro]
	role = "Basic"
	description = "Roll a die. If you rolled a 1 or 2, inflict Poison 5. If you rolled a 3 or 4, inflict Burn 5. If you rolled a 5 or 6, inflict Fear 5."
	name = "Status Roulette"
	tags = ['Utility']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
