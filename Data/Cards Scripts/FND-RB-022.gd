extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Search your deck for any card, then put it into the graveyard."
	name = "Call of the Damned"
	tags = ['Utility', 'Self-Target', 'Omen']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
