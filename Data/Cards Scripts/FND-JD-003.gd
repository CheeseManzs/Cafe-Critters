extends Card

func _init() -> void:
	cost = 2
	priority = 3
	alignment = ALIGNMENT.Jacks
	description = "Discard your hand. Gain (20% DEF) block per card discarded."
	name = "I'm Out"
	tags = ['Defence']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
