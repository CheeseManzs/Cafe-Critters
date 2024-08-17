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
	if a.playerControlled && !b.playerControlled:
		return true
	if b.playerControlled && !a.playerControlled:
		return false
	if a.priority == b.priority:
		return randomBool()

func rearrange() -> void:
	actions.sort_custom(sortAction)

func runActions(battleController: Node) -> void:
	print('running turns')
	for i in len(actions):
		var action = actions[i]
		
		#run attack action
		
		if action.defaultAction == BattleAction.DEFAULT_ACTION.ATTACK:
			var val = BattleController.actionAttack(action.battleMonster, action.target)
			action.printAction(val)
		#run defend action
		if action.defaultAction == BattleAction.DEFAULT_ACTION.DEFEND:
			var val = BattleController.actionDefend(action.battleMonster)
			action.printAction(val)
		#run card action
		if action.defaultAction == BattleAction.DEFAULT_ACTION.NONE:
			print('card action')
			#action.card.effect(action.battleMonster, action.target)
		await battleController.get_tree().create_timer(0.75).timeout
		print('done turn')
