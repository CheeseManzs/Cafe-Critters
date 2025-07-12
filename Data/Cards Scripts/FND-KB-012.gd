extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Swap to a shelved fae. It heals (5% Max HP) health."
	name = "Crossfade"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
