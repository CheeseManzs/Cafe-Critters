class_name PassiveAbility
extends Resource

var name = ""
var desc = ""
var initialized = false

func _init() -> void:
	name = "Undefined"
	desc = "N/A"



func initPassive(mon: BattleMonster, battle: BattleController):
	if !initialized:
		initialized = true
		await activateAbility(mon, battle)

#runs whenever the ability is activated (should be implemented into every overridden function)
func activateAbility(mon: BattleMonster, battle: BattleController) -> void:
	return

#ability events:

#runs when a monster is damaged by another monster/passive/status
func onHit(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a monster attacks
func onAttack(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a monster is afflicted with a status
func onStatus(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a turn starts
func onTurnStart(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a turn ends
func onTurnEnd(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a sub-turn starts
func onSubTurnStart(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a sub-turn ends
func onSubTurnEnd(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a mon is KO'd
func onSelfKO(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a mon KO's another mon
func onOtherKO(mon: BattleMonster, battle: BattleController) -> void:
	return
