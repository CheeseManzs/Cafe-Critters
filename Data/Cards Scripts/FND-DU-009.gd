extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Empower the next card played."
	name = "Caffeinate"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	await giveStatus_noempower(attacker,Status.EFFECTS.EMPOWER_PLAYED)
	return 0

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.EMPOWER_PLAYED)
