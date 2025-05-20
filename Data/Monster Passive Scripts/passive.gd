class_name PassiveAbility
extends Resource

var name = ""
var desc = ""
var initialized = false
@export var flairColour: Color

func _init() -> void:
	name = "Undefined"
	desc = "N/A"

func createFlair(mon: BattleMonster):
	await EffectFlair.singleton._runFlair(mon.rawData.name,flairColour)
	return
	
func createSpecialFlair(specText: String, specColour: Color):
	await EffectFlair.singleton._runFlair(specText,specColour)
	return

func createUI(mon: BattleMonster, battle: BattleController, packedscene: PackedScene):
	var container: VBoxContainer
	if mon.playerControlled:
		container = battle.playerUI[0].externalGaugeContainer
	else:
		container = battle.enemyUI[0].externalGaugeContainer 
	var newObj = packedscene.instantiate()
	container.add_child(newObj)
	return newObj

func customUI(mon: BattleMonster, battle: BattleController):
	return

func initPassive(mon: BattleMonster, battle: BattleController):
	if !initialized:
		initialized = true
		await activateAbility(mon, battle)
		if battle.getActivePlayerMon() == mon || battle.getActiveEnemyMon() == mon:
			await customUI(mon, battle)

#runs whenever the ability is activated (should be implemented into every overridden function)
func activateAbility(mon: BattleMonster, battle: BattleController) -> void:
	return

#ability events:

func onSwapOut(mon: BattleMonster, battle: BattleController) -> void:
	return
	
func onSwapIn(mon: BattleMonster, battle: BattleController) -> void:
	return
	
func onSwapIn_beforeSwap(newMon: BattleMonster, oldMon: BattleMonster, battle: BattleController) -> void:
	return
	
func onSwapOut_beforeSwap(newMon: BattleMonster, oldMon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a monster is damaged by another monster/passive/status
func onHit(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a monster attacks
func beforeAttack(mon: BattleMonster, battle: BattleController, card: Card) -> void:
	return
	
#runs when a conditional effect triggers
func onConditional(mon: BattleMonster, battle: BattleController, card: Card) -> void:
	return
	
#runs when a monster attacks
func onAttack(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a monster is afflicted with a status
func onStatus(mon: BattleMonster, battle: BattleController, status: Status) -> void:
	return

#runs when a turn starts
func onTurnStart(mon: BattleMonster, battle: BattleController) -> void:
	return

func attackBonus(mon: BattleMonster, battle: BattleController) -> float:
	return 0
	
func defenseBonus(mon: BattleMonster, battle: BattleController) -> float:
	return 0

func switchCostModifier_active(mon: BattleMonster, battle: BattleController, currentCost: int) -> float:
	return 0

func switchCostModifier_shelved(mon: BattleMonster, battle: BattleController, activeMon: BattleMonster, currentCost: int) -> int:
	return 0

#runs when a turn ends
func onTurnEnd(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a sub-turn starts
func onSubTurnStart(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a sub-turn ends
func onSubTurnEnd(mon: BattleMonster, battle: BattleController) -> void:
	return

func onHeal(mon: BattleMonster, battle: BattleController, card: Card) -> void:
	return

func onDiscard(mon: BattleMonster, battle: BattleController, card: Card) -> void:
	return

#runs when a mon is KO'd
func onSelfKO(mon: BattleMonster, battle: BattleController) -> void:
	return

#runs when a mon KO's another mon
func onOtherKO(mon: BattleMonster, battle: BattleController) -> void:
	return

func diceTransform(mon: BattleMonster, battle: BattleController, diceNumber: int, maxNumber: int = 6) -> int:
	return diceNumber
