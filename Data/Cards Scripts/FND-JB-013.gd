extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks [Aggro]
	role = "Basic"
	description = "Deal (45% ATK) damage. If this Attack hits, shuffle it into your deck and draw 1."
	name = "Steel Shuffler"
	tags = ['Attack']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
