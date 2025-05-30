extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Deal (10% ATK) damage for every stack of Focus and Fatigue. If this card is played with a modified cost, deal (20% ATK) damage instead."
	name = "Press"
	tags = ['Utility']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
