extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Rev"
	description = "If the opposing Fae plays a card targeting Rev or it's team this turn, that card is played targeting the opposing Fae or their team instead. If this effect triggers, gain 1 mp."
	name = "Perfect Parry"

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(attacker, Status.EFFECTS.PERFECT_PARRY)

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.PERFECT_PARRY)
