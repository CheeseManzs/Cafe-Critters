extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks [Aggro]
	role = "Basic"
	description = "All damage is doubled this turn."
	name = "Up the Ante"
	tags = ['Utility', ' Self-Target']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
