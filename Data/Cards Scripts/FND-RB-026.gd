extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
	role = ""
	description = "Omen. Inflict Fear 10, your faes can no longer play any more cards this turn."
	name = "Spooky Stories"
	tags = ['Utility', 'Omen']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
