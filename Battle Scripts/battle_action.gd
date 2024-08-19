#container class for data of a specific action in a battle
class_name BattleAction

#priority of attack
var priority: int = 0
#is mon switching out
var switching = true
#monster being targeted
var targetID: int = -1
var targetSelfTeam: bool = false
var card: Card = null
#connected battle monster
var battleMonster: BattleMonster
var battleController: BattleController
var playerControlled = false

func _init(p_battleMon: BattleMonster, p_playerControlled: bool, prio: int, targID: int, targSelf: bool, p_card: Card,p_controller: BattleController, p_switching = false) -> void:
	battleMonster = p_battleMon
	playerControlled = p_playerControlled
	priority = prio
	targetID = targID
	targetSelfTeam = targSelf
	card = p_card
	battleController = p_controller
	switching = p_switching

func getSwitchTarget() -> BattleMonster:
	var tID: int = targetID
	if playerControlled:
		return battleController.playerTeam[targetID]
	else:
		return battleController.enemyTeam[targetID]

func runSwitch() -> void:
	if playerControlled:
		battleController.playerSwap(targetID)
	else:
		battleController.enemySwap(targetID)

# Gets live target
func getTarget() -> BattleMonster:
	var target: BattleMonster
	var tID: int = targetID
	if (playerControlled && targetSelfTeam) || (!playerControlled && !targetSelfTeam):
		if tID == -1:
			tID = battleController.activePlayerMon
		target = battleController.playerTeam[tID]
	if (!playerControlled && targetSelfTeam) || (playerControlled && !targetSelfTeam):
		if tID == -1:
			tID = battleController.activeEnemyMon
		target = battleController.enemyTeam[tID]
	return target
	
func printAction():
	if switching:
		BattleLog.singleton.log(battleMonster.rawData.name + " switched out")
		return
	#target of action
	var target: BattleMonster = getTarget()

	var targName: String = target.rawData.name
	#user of action
	var plrName: String = battleMonster.rawData.name
	#text to print
	var printText: String
	printText = plrName + " used " + card.name
	#send text to battle log
	BattleLog.singleton.log(printText)
	
