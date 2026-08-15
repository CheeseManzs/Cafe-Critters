extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Discard a card, then deal (50% ATK + Discarded Card's ATK) damage."
	name = "Breakneck Barrage"
	tags = ['Attack']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
