class_name BattleSequence

var actions: Array[BattleAction]

func _init(actionList: Array[BattleAction]):
	actions = actionList
	rearrange()

func randomBool() -> bool:
	var boolArr = [true, false]
	if BattleController.multiplayer_game && !ConnectionManager.host:
		boolArr.reverse()
	return boolArr[BattleController.global_rng.randi_range(0,1)]

func sortAction(a:BattleAction, b:BattleAction):
	if a.priority > b.priority:
		return true
	if a.priority < b.priority:
		return false
	if a.battleMonster.speed > b.battleMonster.speed:
		return true
	if a.battleMonster.speed < b.battleMonster.speed:
		return false
	if a.priority == b.priority && a.battleMonster.speed == b.battleMonster.speed:
		return randomBool()

func rearrange() -> void:
	actions.sort_custom(sortAction)

func runActions(battleController: Node) -> void:
	for i in len(actions):
		var action = actions[i]
		if action.battleMonster.hasStatus(Status.EFFECTS.KO) && !action.switching:
			#if action.battleMonster == battleController.getActivePlayerMon():
			#	await battleController.promptPlayerSwitch()
			#continue
			#end turn if monster is fainted and not switching
			break
		
		#run card action
		action.printAction()
		if action.switching:
			action.battleMonster.removeMP(1)
			await action.runSwitch()
			await battleController.get_tree().create_timer(1.0).timeout
			continue
		
		#if empower next played: empower card
		if action.battleMonster.hasStatus(Status.EFFECTS.EMPOWER_PLAYED):
			action.battleMonster.getStatus(Status.EFFECTS.EMPOWER_PLAYED).effectDone = true
			action.card.statusConditions.push_back(Status.EFFECTS.EMPOWER)
			await battleController.get_tree().create_timer(0.75).timeout
			BattleLog.log(action.card.name + " was Empowered!")
			await EffectFlair.singleton._runFlair("Empowered",Color.LIME_GREEN)
		#if opponent has boil, give MP
		var opposingMon: BattleMonster = action.battleController.getOpposingMon(action.battleMonster.playerControlled)
		if opposingMon != null && opposingMon.hasStatus(Status.EFFECTS.BOIL) && !opposingMon.getStatus(Status.EFFECTS.BOIL).effectDone:
			await battleController.get_tree().create_timer(0.25).timeout
			await EffectFlair.singleton._runFlair("Boil",Color.BURLYWOOD)
			var regenLevel = 0
			#if opposingMon.hasStatus(Status.EFFECTS.REGEN):
				#regenLevel = opposingMon.getStatus(Status.EFFECTS.REGEN).X
			opposingMon.addStatusCondition(Status.new(Status.EFFECTS.REGEN,regenLevel+1),true)
			#await battleController.get_tree().create_timer(0.75).timeout
		
		action.battleMonster.removeMP(action.card.cost)
		
		await action.battleMonster.getPassive().beforeAttack(action.battleMonster,action.battleController, action.card)
		await battleController.get_tree().create_timer(0.75).timeout
		await action.card.effect(action.battleMonster, action.getTarget())
		await battleController.addToGraveyard(action.card)
		await battleController.get_tree().create_timer(0.75).timeout
