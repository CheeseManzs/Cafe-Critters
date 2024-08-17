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

func _init(prio: int, targ: BattleMonster, p_card: Card, defAction: DEFAULT_ACTION = DEFAULT_ACTION.NONE) -> void:
	priority = prio
	target = targ
	card = p_card
	defaultAction = defAction
	
