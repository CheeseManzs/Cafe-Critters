extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Take (300% Opponent ATK). Draw 5 and gain 3 MP."
	name = "Last Chance"
	tags = ['Utility', ' Self-Target']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
