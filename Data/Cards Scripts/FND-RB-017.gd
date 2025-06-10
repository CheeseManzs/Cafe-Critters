extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Inflict Poison 3."
	name = "Paranoia"
	tags = ['Utility', 'Omen']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	await applyOmen(attacker, defender)
	await giveStatus(defender, Status.EFFECTS.POISON, 3)
	

func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.POISON, 3)
