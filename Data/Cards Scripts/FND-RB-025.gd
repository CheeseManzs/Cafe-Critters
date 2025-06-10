extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Trigger all Omen cards in the graveyard."
	name = "Toll the Bells"
	tags = ['Utility', 'Self-Target', 'Omen Proc']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	await applyOmen(attacker, defender)
