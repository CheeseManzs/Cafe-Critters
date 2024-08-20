class_name BattleAI

var battleController: BattleController

func _init(controller: BattleController) -> void:
	battleController = controller

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
		for otherMon in battleController.enemyTeam:
			if otherMon.health > mon.health:
				shouldSwich = true
	return shouldSwich

func choiceEnemy(removeChoice = false):
	
	#get current enemy mp
	var MP: int = battleController.enemyMP
	#get current enemy mon
	var mon: BattleMonster = battleController.getActiveEnemyMon()
	var plrMon: BattleMonster = battleController.getActivePlayerMon()
	#get current enemy cards
	var cards: Array[Card] = mon.currentHand.storedCards
	
	#check for all possible choices
	var available: Array[Card] = []
	#keep track of how behind the enemy is in terms of mana production
	var requiredMP = 0
	
	for card in cards:
		if card.cost <= MP:
			available.push_back(card)
		else:
			requiredMP += card.cost - MP
	
	#calculate scores for all possible choices
	var scores = []
	var maxScore = -1
	var bestCard = null
	for card in available:
		var score = 0
		score += card.calcBonus(mon, plrMon)
		score += card.calcDamage(mon, plrMon)*3
		score += card.calcShield(mon,plrMon)/2
		if mon.maxHP < plrMon.attack*2:
			score += card.calcShield(mon,plrMon)/2
		if card.role == Card.ROLE.Unique || card.role == Card.ROLE.Point:
			score += 5
		scores.push_back(score)
		if score > maxScore:
			maxScore = score
			bestCard = card
	#return best card
	
	if removeChoice:
		mon.currentHand.storedCards.remove_at(mon.currentHand.storedCards.find(bestCard))
		
	return bestCard
	
