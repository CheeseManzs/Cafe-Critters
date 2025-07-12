extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Deal (20% ATK) damage times the amount of skills your team played last round."
	name = "Beat Drop"
	tags = ['Attack']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
