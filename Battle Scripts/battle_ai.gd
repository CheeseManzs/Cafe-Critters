class_name BattleAI

var battleController: BattleController

func _init(controller: BattleController) -> void:
	battleController = controller

func maxDamage(mon: BattleMonster, target: BattleMonster):
	var dmgs = [0]
	for card in mon.currentHand.storedCards:
		#calculate damage
		var dmg = card.calcDamage(mon, target)
		dmgs.append(dmg)
	
	#return highest damage number
	return dmgs.max()

func factorial(x: int) -> int:
	var n: int = 1
	for i in (x + 1):
		if i != 0:
			n *= i
	return n

func scoreStatus(status: Status, mon: BattleMonster) -> float:
	if status == null:
		return 0
	match status.effect:
		Status.EFFECTS.KO:
			return -100
		Status.EFFECTS.DECAY:
			return -status.X
		Status.EFFECTS.EMPOWER:
			return 0
		Status.EFFECTS.EMPOWER_NEXT:
			return 0
		Status.EFFECTS.EMPOWER_PLAYED:
			return 3
		Status.EFFECTS.HASTE:
			return status.X
		Status.EFFECTS.SLOW:
			return -status.X
		Status.EFFECTS.SUSPEND:
			return -status.X
		Status.EFFECTS.DREDGE:
			return 0
		Status.EFFECTS.FLOTSAM:
			return 0
		Status.EFFECTS.SALVAGE:
			return 0
		Status.EFFECTS.PITCH:
			return 0
		Status.EFFECTS.KNOWLEDGE:
			return status.X
		Status.EFFECTS.BARRIER:
			return mon.health
		Status.EFFECTS.REGEN:
			var missingHP = mon.maxHP - mon.health
			return min(missingHP + status.X, factorial(status.X))
		Status.EFFECTS.RECKLESS:
			return -1
		Status.EFFECTS.STRONGARM:
			return len(mon.currentHand.storedCards)
	return 0

func scoreCard(mon: BattleMonster, target: BattleMonster, card: Card):
	#setup scoring
	var score = 0
	
	#get damage from scores
	var monDamage = card.calcDamage(mon, target)
	var targDamage = maxDamage(target, mon)
	
	score += min(monDamage,target.health + target.shield)
	score += card.calcShield(mon,target)*targDamage
	
	var statusGiven: Status = card.calcStatusGiven(mon, target)
	var statusInflicted: Status = card.calcStatusInflicted(mon, target)
	var statusCured: Status.EFFECTS = card.calcStatusCured(mon, target)
	
	if statusGiven != null:
		score += scoreStatus(statusGiven, mon)
	if statusInflicted != null:
		score += -scoreStatus(statusInflicted, target)
	if statusCured != Status.EFFECTS.NONE:
		score += -scoreStatus(Status.new(statusCured), mon)
	
	return score

func enemyPossibleSwitch():
	
	var bestIndex = -1
	var bestScore = 0
	for mon in battleController.enemyTeam:
		if mon != battleController.getActiveEnemyMon():
			var score = scoreMon(mon, battleController.getActivePlayerMon())[1]
			if score > bestScore:
				bestIndex = battleController.enemyTeam.find(mon)
				bestScore = score
	
	return -1

func enemySwitch():
	#run advanced check
	for mon in battleController.enemyTeam:
		var oldMon = battleController.getActiveEnemyMon()
		var newMon = mon
		if newMon.health > oldMon.health && battleController.validSwap(oldMon, newMon) && len(newMon.playableCards()) > 0:
			return battleController.enemyTeam.find(mon)
	#if no match, find first valid switch
	for mon in battleController.enemyTeam:
		var oldMon = battleController.getActiveEnemyMon()
		var newMon = mon
		if battleController.validSwap(oldMon, newMon) && len(newMon.playableCards()) > 0:
			return battleController.enemyTeam.find(mon)
		
	for mon in battleController.enemyTeam:
		var oldMon = battleController.getActiveEnemyMon()
		var newMon = mon
		if battleController.validSwap(oldMon, newMon):
			return battleController.enemyTeam.find(mon)
	return -1

func enemyShouldSwitch():
	var shouldSwich = false
	#get active monster
	var mon = battleController.getActiveEnemyMon()
	#if monster is at or below 50% hp then switch out
	if float(mon.health)/float(mon.maxHP) <= 0.5:
		var switchScore = 0
		for otherMon in battleController.enemyTeam:
			if otherMon.health > mon.health:
				shouldSwich = true
	return shouldSwich

#choose cards from hand
func enemyChooseHand(count: int, requirement: Callable = func(x): return true) -> Array[Card]:
	var mon: BattleMonster = battleController.getActiveEnemyMon()
	var cards: Array[Card] = mon.currentHand.storedCards
	var chosen: Array[Card] = []
	for card in cards:
		if len(chosen) < count && requirement.call(card):
			chosen.push_back(card)
	return chosen
		

func enemyShelfed(count: int) -> Array[BattleMonster]:
	var choices: Array[BattleMonster] = []
	#choose shelfed mons
	for mon in battleController.enemyTeam:
		#make sure mon isnt the active mon
		if len(choices) < count && mon != battleController.getActiveEnemyMon() && !mon.isKO():
			choices.push_back(mon)
	return choices

func scoreMon(mon: BattleMonster, target: BattleMonster) -> Array:
	var cards: Array[Card] = mon.currentHand.storedCards
	
	#check for all possible choices
	var available: Array[Card] = []
	#keep track of how behind the enemy is in terms of mana production
	var requiredMP = 0
	var MP: int = battleController.enemyMP
	if mon.playerControlled:
		MP = battleController.playerMP
	for card in cards:
		if card.cost <= MP:
			available.push_back(card)
		else:
			requiredMP += card.cost - MP
	
	#calculate scores for all possible choices
	var scores = []
	var maxScore: int = -999
	var bestCard: Card = null
	print("--------")
	for card in available:
		var score = scoreCard(mon, target, card)
		print(card.name+": ",score)
		if score > maxScore:
			maxScore = score
			bestCard = card
	print(bestCard)
	return [bestCard, maxScore]

func choiceEnemy(removeChoice = false):
	#get current enemy mon
	var mon: BattleMonster = battleController.getActiveEnemyMon()
	var plrMon: BattleMonster = battleController.getActivePlayerMon()
	
	var choice = scoreMon(mon, plrMon)
	var bestCard: Card = choice[0]
	print(bestCard.name)
	#return best card
	if choice[1] <= 0:
		return null
	
	if removeChoice:
		mon.currentHand.storedCards.remove_at(mon.currentHand.storedCards.find(bestCard))
		
	return bestCard
	
