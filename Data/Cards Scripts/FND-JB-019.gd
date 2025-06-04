extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Deal (75% ATK) damage. If this Attack hits, the target loses half of their positive statuses."
	name = "Stack Breaker"
	tags = ['Attack']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
