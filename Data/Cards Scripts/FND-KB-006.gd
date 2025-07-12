extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Deal (10% ATK) unblockable damage. If you played 5+ skills last turn, deal (15% ATK) more unblockable damage."
	name = "Sonic Boom"
	tags = ['Attack']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
