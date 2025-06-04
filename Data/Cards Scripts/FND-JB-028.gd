extends Card

func _init() -> void:
	cost = 0
	priority = 1
	alignment = ALIGNMENT.Jacks [Aggro]
	role = "Basic"
	description = "Both players take turns rolling dice until a 1 is rolled, starting with the opponent. When a player rolls a 1, Execute their active fae."
	name = "Toby"
	tags = ['Utility']
	rarity = RARITY.Legendary

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
