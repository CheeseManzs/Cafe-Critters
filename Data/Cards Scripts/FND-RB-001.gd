extends Card

func _init() -> void:
	cost = 4
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. The opponent cannot choose to swap out this turn. If this effect is already active, extend it by 1 turn."
	name = "Corner"
	tags = ['Utility', 'Omen']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	await applyOmen(attacker, defender)
	await giveStatus(defender, Status.EFFECTS.TRAPPED, 1)
	

func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.TRAPPED, 1)
