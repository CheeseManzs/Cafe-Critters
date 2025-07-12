extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "The next 3 cards you play deal (25% ATK) more damage."
	name = "Augmented Triad"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
