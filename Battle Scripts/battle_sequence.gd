class_name BattleSequence

var actions: Array[BattleAction]

func _init(actionList: Array[BattleAction]):
	actions = actionList
	rearrange()

func randomBool() -> bool:
	var boolArr = [true, false]
	return boolArr.pick_random()

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
			action.runSwitch()
			await battleController.get_tree().create_timer(1.0).timeout
			continue
		
		#if empower next played: empower card
		if action.battleMonster.hasStatus(Status.EFFECTS.EMPOWER_PLAYED):
			action.battleMonster.getStatus(Status.EFFECTS.EMPOWER_PLAYED).effectDone = true
			action.card.statusConditions.push_back(Status.EFFECTS.EMPOWER)
			await battleController.get_tree().create_timer(0.75).timeout
			BattleLog.log(action.card.name + " was Empowered!")
			await EffectFlair.singleton._runFlair("Empowered",Color.LIME_GREEN)
			#await battleController.get_tree().create_timer(0.75).timeout
		
		action.battleMonster.removeMP(action.card.cost)
		
		await battleController.get_tree().create_timer(0.75).timeout
		await action.card.effect(action.battleMonster, action.getTarget())
		await battleController.addToGraveyard(action.card)
		await battleController.get_tree().create_timer(0.75).timeout
