extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Double you Focus and double your opponent's Fatigue. Gain 1 MP."
	name = "Double Double"
	tags = ['Utility']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
