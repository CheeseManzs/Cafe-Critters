extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Inflict Poison 3."
	name = "Paranoia"
	tags = ['Utility', 'Omen']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
