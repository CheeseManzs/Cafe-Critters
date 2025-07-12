extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Deal (30% ATK) damage. If this is the first skill you've played this round, deal (20% ATK) more damage and create an Inspiration in hand."
	name = "Downbeat Beatdown"
	tags = ['Attack']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
