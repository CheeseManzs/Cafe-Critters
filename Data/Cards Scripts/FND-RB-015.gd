extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "If a Defence has been placed into your graveyard this turn, gain (120% DEF) block."
	name = "Spirit Barrier"
	tags = ['Defence']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
