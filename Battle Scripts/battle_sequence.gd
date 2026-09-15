class_name BattleSequence

var actions: Array[BattleAction]

func _init(actionList: Array[BattleAction]):
	actions = actionList
	rearrange()

func randomBool() -> bool:
	var boolArr = [true, false]
	BattleMonster.totalDraws += 1
	return boolArr[BattleController.global_rng.randi_range(0,1)]

func definiteArrangement(a:BattleAction, b:BattleAction):
	if a.battleMonster.gameID > b.battleMonster.gameID:
		return true
	else:
		return false

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
	actions.sort_custom(definiteArrangement) #sort in a definite order first to avoid extra sort action calculations 
	actions.sort_custom(sortAction)

func runActions(battleController: BattleController) -> void:
	var i = -1
	
	#check if mon skipped
	var skipList = [false, false]
	var monList = battleController.sortedActiveMonList()
	
	for action in actions:
		for id in len(monList):
			if action.battleMonster == monList[id]:
				skipList[id] = true
	
	for skipID in len(skipList):
		if !skipList[skipID]:
			await monList[skipID].onSkip()
			print("what")
			
	for action in actions:
		if action.card != null:
			await action.card.earlyEffect(action.battleMonster, action.getTarget())
			
	while i+1 < len(actions):
		i += 1
		var action = actions[i]
		if action.battleMonster.isKO() && !action.switching:
			break
		
		#run card action
		action.printAction()
		if action.switching:
			action.battleMonster.removeMP(action.battleController.getSwitchCost())
			await action.runSwitch()
			await battleController.get_tree().create_timer(1.0).timeout
			continue
		
		var cardCost = action.card.getRealCost()*action.costMod
		print("card stats: ", action.card.cost, ", ", action.card.costMod)
		action.battleMonster.removeMP(cardCost)
		action.card.playedCost = cardCost
		
		# Before attack effects
		
		var skipEffect = false
		
		for status in action.battleMonster.statusConditions:
			await status.beforeCardPlayed(action.battleMonster, action.card)
			
			if status.p_skipsNextCard(action.battleMonster, action.card):
				BattleLog.log(status.name + " nullified the effects of " + action.card.name+"!")
				skipEffect = true
		
		await battleController.get_tree().create_timer(0.75).timeout
		
		#add card to play history
		await action.battleMonster.addCardToHistory(action.card)
		
		if !skipEffect:
			await action.card.effect(action.battleMonster, action.getTarget())
		
		await battleController.addToGraveyard(action.card, action.battleMonster)
		
		action.battleMonster.playedCardThisTurn = true
		
		await battleController.get_tree().create_timer(0.75).timeout
		
		# After card effects
		for status in action.battleMonster.statusConditions:
			await status.onCardPlayed(action.battleMonster, action.card)
		
