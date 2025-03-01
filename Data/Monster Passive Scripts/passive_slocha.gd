extends PassiveAbility

func _init() -> void:
	name = "Refreshing Tea"
	desc = "N/A"

func onStatus(mon: BattleMonster, battle: BattleController, status: Status) -> void:
	if status.effect == Status.EFFECTS.EMPOWER_PLAYED:
		await EffectFlair.singleton._runFlair(mon.rawData.name,Color.SADDLE_BROWN)
		await mon.addStatusCondition(Status.new(Status.EFFECTS.HASTE, 1), true)
		await battle.getOpposingMon(mon.playerControlled).addStatusCondition(Status.new(Status.EFFECTS.SLOW, 1), true)
	return

func beforeAttack(mon: BattleMonster, battle: BattleController, card: Card) -> void:
	pass
	#if card.statusConditions.has(Status.EFFECTS.EMPOWER):
	#	await EffectFlair.singleton._runFlair(mon.rawData.name,Color.SADDLE_BROWN)
	#	await mon.addStatusCondition(Status.new(Status.EFFECTS.HASTE, 1), true)
	#	await battle.getOpposingMon(mon.playerControlled).addStatusCondition(Status.new(Status.EFFECTS.SLOW, 1), true)
	#return
