extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Deal (60% ATK) damage. If this card is played with a modified cost, gain Focus 2."
	name = "Expresso"
	tags = ['Attack']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
