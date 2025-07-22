extends PassiveAbility

var turnCounter = 0

func _init() -> void:
	name = "Paralyzing Gaze"
	desc = "Every 3 turns, Phantavision traps the opponent on the field until the end of the turn."

func onTurnStart(mon: BattleMonster, battle: BattleController) -> void:
	turnCounter = (turnCounter + 1)%3
	
	if turnCounter == 0:
		await createFlair(mon)
		var trapStatus = Status.new(Status.EFFECTS.TRAPPED)
		await battle.getOpposingMon(mon.playerControlled).addStatusCondition(trapStatus,true)
	
