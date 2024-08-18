#container class for data of a specific action in a battle
class_name BattleAction

#priority of attack
var priority: int = 0
#monster being targeted
var targetID: int = -1
var targetSelfTeam: bool = false
var card: Card = null
#connected battle monster
var battleMonster: BattleMonster
var battleController: BattleController
var playerControlled = false

func _init(p_battleMon: BattleMonster, p_playerControlled: bool, prio: int, targID: int, targSelf: bool, p_card: Card,p_controller: BattleController) -> void:
	battleMonster = p_battleMon
	playerControlled = p_playerControlled
	priority = prio
	targetID = targID
	targetSelfTeam = targSelf
	card = p_card
	battleController = p_controller

# Gets live target
func getTarget() -> BattleMonster:
	var target: BattleMonster
	
	if (playerControlled && targetSelfTeam) || (!playerControlled && !targetSelfTeam):
		if targetID == -1:
			targetID = battleController.activePlayerMon
		target = battleController.playerTeam[targetID]
	if (!playerControlled && targetSelfTeam) || (playerControlled && !targetSelfTeam):
		if targetID == -1:
			targetID = battleController.activeEnemyMon
		target = battleController.enemyTeam[targetID]
	return target
	
func printAction():
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
	
