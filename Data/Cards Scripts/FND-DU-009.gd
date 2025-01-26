extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Empower the next card played."
	name = "Caffeinate"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	await giveStatus_noempower(attacker,Status.EFFECTS.EMPOWER_PLAYED)
	return 0

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.EMPOWER_PLAYED)
