extends Card

func _init() -> void:
	cost = 4
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Forward"
	description = "Omen. Opponent Fae discards a card."
	name = "Relentless Thoughts"
	tags = ["Omen"]

func effect(attacker: BattleMonster, defender: BattleMonster):
	await defender.discardRandomCard()
	await applyOmen(attacker, defender)
	pass
