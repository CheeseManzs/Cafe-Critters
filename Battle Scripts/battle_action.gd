#container class for data of a specific action in a battle
class_name BattleAction

#priority of attack
var priority: int = 0
#monster being targeted
var target: BattleMonster = null
var card: Card = null
#connected battle monster
var battleMonster: BattleMonster
var playerControlled = false

func _init(p_battleMon: BattleMonster, p_playerControlled: bool, prio: int, targ: BattleMonster, p_card: Card) -> void:
	battleMonster = p_battleMon
	playerControlled = p_playerControlled
	priority = prio
	target = targ
	card = p_card

func printAction(value: int):
	var targName: String = target.rawData.name
	var plrName: String = battleMonster.rawData.name
	var initText: String
	var printText: String
	printText = plrName + " used " + card.name.to_lower() + " > " + str(value)
	BattleLog.singleton.log(printText)
	
