extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Create 3 copies of Inspiration in hand. Gain Focus 1."
	name = "Intensive Study"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
