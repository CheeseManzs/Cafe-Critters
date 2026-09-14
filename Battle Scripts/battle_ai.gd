class_name BattleAI

var battleController: BattleController

var personality: AIPersonality
var STANDARD_BONUS = 100


func _init(controller: BattleController, p_person: AIPersonality) -> void:
	battleController = controller
	personality = p_person.clone()

func maxDamage(mon: BattleMonster, target: BattleMonster):
	var currentMP = mon.battleController.enemyMP
	if mon.playerControlled:
		currentMP = mon.battleController.playerMP
	
	var dmgs = [0]
	for card in mon.currentHand.storedCards:
		#calculate damage
		var dmg = 0
		
		var ineligible = card.cost > currentMP || mon.statusBlockingCard(card)
		if !ineligible:
			dmg = card.calcDamage(mon, target)
		
		dmgs.append(dmg)
	
	#return highest damage number
	return dmgs.max()

func maxBlock(mon: BattleMonster, target: BattleMonster):
	var currentMP = mon.battleController.enemyMP
	if mon.playerControlled:
		currentMP = mon.battleController.playerMP
	
	var blks = [0]
	for card in mon.currentHand.storedCards:
		#calculate damage
		var blk = 0
		
		var ineligible = card.cost > currentMP || mon.statusBlockingCard(card)
		if !ineligible:
			blk = card.calcShield(mon, target)
		
		blks.append(blk)
	
	#return highest damage number
	return blks.max()

func additive_factorial(x: int) -> int:
	var n: int = 0
	for i in (x + 1):
		n += i
	return n

func factorial(x: int) -> int:
	var n: int = 1
	for i in (x + 1):
		if i != 0:
			n *= i
	return n

func scoreStatus(status: Status, mon: BattleMonster, currentMP: int = 0) -> float:
	if status == null:
		return 0
	return status.aiScore()


#gets the chance that a card will successfully occur
func getChance(card: Card, attacker: BattleMonster, defender: BattleMonster):
	var fits: float = 0
	var total: float = len(attacker.currentHand.storedCards)
	
	if attacker.currentHand.storedCards.has(card):
		total -= 1
	
	for other in attacker.currentHand.storedCards:
		if card != other && card.meetsRequirement(other, attacker, defender):
			fits += 1
	if total == 0:
		return 1
	var perc = fits/total
	return perc

func scoreCard(mon: BattleMonster, target: BattleMonster, card: Card, activeMon: BattleMonster, currentMP = 0, targetMP = 0):
	#setup scoring
	var score = 0
	print("scoring...")
	#get damage from scores
	var monDamage = card.calcDamage(mon, target)
	var targDamage = maxDamage(target, mon)
	#effective hp of target
	var targEffHP = min(monDamage,target.health + target.shield)
	
	var cardDMG = min(monDamage,target.health + target.shield)
	
	
	var cardDEF = card.calcShield(mon,target)*targDamage
	
	var statusGiven: Status = card.calcStatusGiven(mon, target)
	var statusInflicted: Status = card.calcStatusInflicted(mon, target)
	var statusCured: Status.EFFECTS = card.calcStatusCured(mon, target)
	var activationChance = getChance(card, mon, target)
	
	#add scores
	score += cardDMG*personality.aggression*activationChance
	score += cardDEF*personality.caution
	
	
	
	if statusGiven != null:
		score += 10*scoreStatus(statusGiven, mon, currentMP)*personality.mechanics
		if mon.hasStatus(statusGiven.effect, card) && statusGiven.X == 0:
			score -= 100
	if statusInflicted != null:
		score += -10*scoreStatus(statusInflicted, target, targetMP)*personality.mechanics*activationChance
	if statusCured != Status.EFFECTS.NONE:
		pass#FIX FUNCTIONALITY LATER#score += -10*scoreStatus(Status.new(statusCured), mon, currentMP)*personality.mechanics
	
	if cardDMG >= targEffHP && activationChance >= 1:
		score += cardDMG*personality.opportunism
	#if card.name == "Steady":
		#print("\n",card.name+": ","\ncardDMG:",+cardDMG,"\nCardDEF:",cardDEF,"\nStatus:",10*(scoreStatus(statusGiven, mon, currentMP)-scoreStatus(statusInflicted, target, targetMP)-scoreStatus(Status.new(statusCured), mon, currentMP)))
	
	score += card.calcBonus(mon, target, self)
	var cost = card.getRealCost()
	if cost == 0:
		cost = 0.5
	return score/cost

func enemyPossibleSwitch():
	
	var bestIndex = -1
	var bestScore = 0
	for mon in battleController.enemyTeam:
		if mon != battleController.getActiveEnemyMon():
			var score = scoreMon(mon, battleController.getActivePlayerMon())[1]
			if score > bestScore:
				bestIndex = battleController.enemyTeam.find(mon)
				bestScore = score
	
	return bestIndex

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
	if battleController.getActiveEnemyMon().isKO():
		return true
	if battleController.getActivePlayerMon() == null || battleController.getActivePlayerMon().isKO():
		return false
	var shouldSwich = false
	#get active monster
	var mon = battleController.getActiveEnemyMon()
	#if monster is at or below 50% hp then switch out
	var scoreToBeat = scoreMonPotential(mon,battleController.getActivePlayerMon())[1]
	
	for otherMon in battleController.enemyTeam:
		if otherMon == mon || !battleController.validSwap(mon, otherMon):
			continue
		var pot = scoreMonPotential(otherMon,battleController.getActivePlayerMon(), 1)[1]*min(1, personality.caution)/10.0
		print("sw/pot: ",scoreToBeat,"/",pot,"|",100*(1 + personality.standards))
		if pot > scoreToBeat && pot >= 100*(1 + personality.standards):
			print("found switch!")
			shouldSwich = true
			break
	return shouldSwich

#choose cards from hand
func enemyChooseHand(count: int, requirement: Callable = func(x): return true) -> Array[Card]:
	var mon: BattleMonster = battleController.getActiveEnemyMon()
	var cards: Array[Card] = mon.currentHand.storedCards
	var chosen: Array[Card] = []
	var scores = []
	for card in cards:
		var score = scoreCard(mon,battleController.getOpposingMon(mon.playerControlled),card,mon)
		scores.push_back(score) 
	
	for i in min(count, len(cards)):
		var minScore = scores.min()
		var card = cards[scores.find(minScore)]
		scores.erase(minScore)
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

func scoreMonPotential(mon: BattleMonster, target: BattleMonster, mpOffset = 0) -> Array:
	var cards: Array[Card] = mon.currentHand.storedCards + mon.currentDeck.storedCards
	var activeMon: BattleMonster
	#check for all possible choices
	var available: Array[Card] = []
	#keep track of how behind the enemy is in terms of mana production
	var requiredMP = 0
	var MP: int = battleController.enemyMP
	var targetMP: int = battleController.playerMP
	
	if mon.playerControlled:
		MP = battleController.playerMP - mpOffset
		targetMP = battleController.enemyMP
		activeMon = mon.battleController.getActivePlayerMon()
	else:
		activeMon = mon.battleController.getActiveEnemyMon()
	for card in cards:
		if card.cost <= MP:
			available.push_back(card)
		else:
			requiredMP += card.cost - MP
	#calculate scores for all possible choices
	var scores = []
	var maxScore: int = -999
	var bestCard: Card = null
	var avg: float = 0
	var tot = 0
	for card in available:
		var score = scoreCard(mon, target, card, activeMon)
		print("potential " + card.name+": ",score)
		avg += score
		tot += 1
		if score > maxScore:
			maxScore = score
			bestCard = card
	if tot > 0:
		avg /= tot
	return [bestCard, avg]

func scoreMon(mon: BattleMonster, target: BattleMonster) -> Array:
	var cards: Array[Card] = mon.currentHand.storedCards
	var activeMon: BattleMonster
	
	#check for all possible choices
	var available: Array[Card] = []
	#keep track of how behind the enemy is in terms of mana production
	var requiredMP = 0
	var MP: int = battleController.enemyMP
	var targetMP: int = battleController.playerMP
	
	if mon.playerControlled:
		MP = battleController.playerMP
		targetMP = battleController.enemyMP
		activeMon = mon.battleController.getActivePlayerMon()
	else:
		activeMon = mon.battleController.getActiveEnemyMon()
	
	for card in cards:
		if card.cost <= MP:
			available.push_back(card)
		else:
			requiredMP += card.cost - MP
	
	#calculate scores for all possible choices
	var scores = []
	var maxScore: int = -999
	var bestCard: Card = null

	for card in available:
		
		var score = scoreCard(mon, target, card, activeMon, MP, targetMP)
		print("score of ", card.name+": ", score)
		if score > maxScore:
			maxScore = score
			bestCard = card
	return [bestCard, maxScore]

func choiceEnemy(removeChoice = false):
	#get current enemy mon
	var mon: BattleMonster = battleController.getActiveEnemyMon()
	var plrMon: BattleMonster = battleController.getActivePlayerMon()
	
	var choice = scoreMon(mon, plrMon)
	var bestCard: Card = choice[0]
	#return best card
	if choice[1] <= personality.standards:
		return null
	
	if removeChoice:
		mon.currentHand.storedCards.remove_at(mon.currentHand.storedCards.find(bestCard))
		
	return bestCard
	
