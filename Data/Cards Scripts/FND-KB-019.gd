extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Deal (45% ATK) damage. If you played 4+ skills last round, create a Chorus in hand."
	name = "Chorus"
	tags = ['Attack']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
