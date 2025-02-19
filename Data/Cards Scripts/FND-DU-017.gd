extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Haatea"
	description = "Consume all Barrier. Gain Regen per Barrier consumed. "
	name = "Barrier Absorption "
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster):
	if attacker.hasStatus(Status.EFFECTS.BARRIER):
		var barrierStatus = attacker.getStatus(Status.EFFECTS.BARRIER)
		await giveStatus(attacker,Status.EFFECTS.REGEN,barrierStatus.X)
		barrierStatus.effectDone

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	if attacker.hasStatus(Status.EFFECTS.BARRIER):
		var barrierStatus = attacker.getStatus(Status.EFFECTS.BARRIER)
		return Status.new(Status.EFFECTS.REGEN, barrierStatus.X)
	return null
