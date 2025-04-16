extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Forward"
	description = "Omen. Inflict Poison 1."
	name = "Dripping Death"
	tags = ["Omen"]

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(defender,Status.EFFECTS.POISON,1)
	await applyOmen(attacker, defender)
	pass

func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.POISON,1)
