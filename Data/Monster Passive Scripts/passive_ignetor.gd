extends MachineAbility

func _init() -> void:
	name = "Combustion Engine"
	desc = "Machine. If Ignetor has at least 4 units of Heat or is Overheated, gain Priority. Otherwise, remove Priority."
#ability events:

func checkHeat(mon: BattleMonster, battle: BattleController):
	pass
#runs when a sub-turn starts
func onSubTurnStart(mon: BattleMonster, battle: BattleController) -> void:
	await checkHeat(mon, battle)
	return

#runs when a sub-turn ends
func onSubTurnEnd(mon: BattleMonster, battle: BattleController) -> void:
	await loseHeat(mon, battle)
	#await checkHeat(mon, battle)
	return
