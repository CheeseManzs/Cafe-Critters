extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "If a Utility has been placed into your graveyard this turn, draw 4, then discard 2 unless you discard a Utility. "
	name = "Hidden Technique"
	tags = ['Utility']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
