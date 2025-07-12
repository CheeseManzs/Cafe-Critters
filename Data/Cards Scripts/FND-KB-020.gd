extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "The next 3 cards you play restore 1 MP."
	name = "Tritone Substitution"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
