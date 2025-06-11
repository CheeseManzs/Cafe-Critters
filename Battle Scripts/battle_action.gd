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
var costMod = 1

func _init(p_battleMon: BattleMonster, p_playerControlled: bool, prio: int, targID: int, targSelf: bool, p_card: Card,p_controller: BattleController, p_switching = false, p_costMod = 1) -> void:
	battleMonster = p_battleMon
	playerControlled = p_playerControlled
	priority = prio
	targetID = targID
	targetSelfTeam = targSelf
	card = p_card
	battleController = p_controller
	switching = p_switching
	costMod = p_costMod
	
	if p_battleMon.hasStatus(Status.EFFECTS.PRIORITY, card):
		priority += p_battleMon.getStatus(Status.EFFECTS.PRIORITY).X+1
		print("added ", p_battleMon.getStatus(Status.EFFECTS.PRIORITY).X+1, " to battle action")

func getSwitchTarget() -> BattleMonster:
	var tID: int = targetID
	if playerControlled:
		return battleController.playerTeam[targetID]
	else:
		return battleController.enemyTeam[targetID]

func runSwitch() -> void:
	if playerControlled:
		await battleController.playerSwap(targetID)
	else:
		await battleController.enemySwap(targetID)

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
	

func clone(bmon: BattleMonster = null, _targID: int = -1):
	if bmon == null:
		bmon = battleMonster
	if _targID == -1:
		_targID = targetID
	return BattleAction.new(bmon,bmon.playerControlled,priority,_targID,targetSelfTeam,card,battleController,switching,costMod)	

func printAction():
	
	#target of action
	if switching:
		BattleLog.singleton.log(battleMonster.rawData.name + " switched out")
		return
	
	
	
	var target: BattleMonster = getTarget()
		
	var targName: String = target.rawData.name
	#user of action
	var plrName: String = battleMonster.rawData.name
	#text to print
	var printText: String
	printText = plrName + " used " + card.name
	#send text to battle log
	BattleLog.singleton.log(printText)
	
