#container class for data of a specific action in a battle
class_name BattleAction

enum DEFAULT_ACTION {
	ATTACK,
	DEFEND,
	NONE
}
#priority of attack
var priority: int = 0
#monster being targeted
var target: BattleMonster = null
var card: Card = null
var defaultAction: DEFAULT_ACTION = DEFAULT_ACTION.NONE
#connected battle monster
var battleMonster: BattleMonster
var playerControlled = false

func _init(p_battleMon: BattleMonster, p_playerControlled: bool, prio: int, targ: BattleMonster, p_card: Card, defAction: DEFAULT_ACTION = DEFAULT_ACTION.NONE) -> void:
	battleMonster = p_battleMon
	playerControlled = p_playerControlled
	priority = prio
	target = targ
	card = p_card
	defaultAction = defAction

func printAction(value: int):
	var targName: String = target.rawData.name
	var plrName: String = battleMonster.rawData.name
	var printText: String
	if defaultAction == DEFAULT_ACTION.ATTACK:
		printText = plrName + " attacked " + targName + " for " + str(value) + " damage" 
	if defaultAction == DEFAULT_ACTION.DEFEND:
		printText = plrName + " gained " + str(value) + " shield" 
	BattleLog.singleton.log(printText)
	
