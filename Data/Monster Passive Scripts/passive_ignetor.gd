extends MachineAbility

func _init() -> void:
	name = "Combustion Engine"
	desc = "Machine. If Shark has at least 4 units of Heat or is Overheated, gain Priority. Otherwise, remove Priority."
#ability events:

func checkHeat(mon: BattleMonster, battle: BattleController):
	if heat >= 4 && !mon.hasStatus(Status.EFFECTS.PRIORITY) && !mon.hasStatus(Status.EFFECTS.OVERHEAT):
		await EffectFlair.singleton._runFlair(mon.rawData.name,Color.DARK_ORANGE)
		BattleLog.singleton.log(mon.rawData.name+" is getting revved up!")
		await mon.addStatusCondition(Status.new(Status.EFFECTS.PRIORITY,1),true)
	elif mon.hasStatus(Status.EFFECTS.PRIORITY):
		mon.statusConditions.erase(mon.getStatus(Status.EFFECTS.PRIORITY))
#runs when a sub-turn starts
func onSubTurnStart(mon: BattleMonster, battle: BattleController) -> void:
	await checkHeat(mon, battle)
	return

#runs when a sub-turn ends
func onSubTurnEnd(mon: BattleMonster, battle: BattleController) -> void:
	await loseHeat(mon, battle)
	await checkHeat(mon, battle)
	return
