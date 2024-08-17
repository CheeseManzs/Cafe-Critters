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
	for i in len(actions):
		var action = actions[i]
		#run card action
		action.printAction()
		action.battleMonster.removeMP(action.card.cost)
		await battleController.get_tree().create_timer(0.75).timeout
		action.card.effect(action.battleMonster, action.target)
		
		await battleController.get_tree().create_timer(0.75).timeout
