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
			
	while i+1 < len(actions):
		i += 1
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
			action.battleMonster.removeMP(action.battleController.getSwitchCost())
			await action.runSwitch()
			await battleController.get_tree().create_timer(1.0).timeout
			continue
		
		#if empower next played: empower card
		if action.battleMonster.hasStatus(Status.EFFECTS.EMPOWER_PLAYED, action.card):
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
		var cardCost = action.card.getRealCost()*action.costMod
		print("card stats: ", action.card.cost, ", ", action.card.costMod)
		action.battleMonster.removeMP(cardCost)
		action.card.playedCost = cardCost
		
		await action.battleMonster.getPassive().beforeAttack(action.battleMonster,action.battleController, action.card)
		await battleController.get_tree().create_timer(0.75).timeout
		
		#parrying
		if !action.card.selfTarget && action.getTarget().hasStatus(Status.EFFECTS.PERFECT_PARRY, action.card):
			await EffectFlair.singleton._runFlair("Perfect Parry",Color.GOLDENROD)
			action.getTarget().getStatus(Status.EFFECTS.PERFECT_PARRY).effectDone = true
			BattleLog.singleton.log(action.getTarget().rawData.name + " parried " + action.card.name)
			action.getTarget().addMP(1)
			await battleController.get_tree().create_timer(0.75).timeout
			
			var targetID = action.battleController.getBattleActionID(action.battleMonster,!action.targetSelfTeam)
			action.targetSelfTeam = !action.targetSelfTeam
			action.targetID = targetID
		
		#add card to play history
		await action.battleMonster.addCardToHistory(action.card)
		
		
				#nullifying effects
		var skipEffect = false
		
		if action.getTarget().hasStatus(Status.EFFECTS.CALL, action.card) && "Attack" in action.card.tags:
			BattleLog.log("Call nullified the effects of " + action.card.name+"!")
			skipEffect = true
		
		if action.getTarget().hasStatus(Status.EFFECTS.BLUFF, action.card) && "Attack" in action.card.tags:
			BattleLog.log("Call nullified the effects of " + action.card.name+"!")
			skipEffect = true
		
		if !skipEffect:
			await action.card.effect(action.battleMonster, action.getTarget())
		
		await battleController.addToGraveyard(action.card, action.battleMonster)
		
		action.battleMonster.playedCardThisTurn = true
		
		await battleController.get_tree().create_timer(0.75).timeout
		
		#poison dipped
		if "Attack" in action.card.tags && action.battleMonster.hasStatus(Status.EFFECTS.POISON_DIPPED, action.card):
			var num = await action.card.rollDice(action.battleMonster)
	
			if num >= 5:
				await action.card.giveStatus(action.getTarget(), Status.EFFECTS.POISON, 5)
		
		if action.battleMonster.hasStatus(Status.EFFECTS.POISON, action.card):
			var poisonStatus: Status = action.battleMonster.getStatus(Status.EFFECTS.POISON)
			await EffectFlair.singleton._runFlair("Poison",Color.MEDIUM_PURPLE)
			var poisonDamage = 0.01*poisonStatus.X*(action.battleMonster.maxHP)
			await action.battleMonster.trueDamage(poisonDamage)
			poisonStatus.addX(-1)
