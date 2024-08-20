class_name ConditionalAction

var activationCallback: Callable
var activationArgs: Array
var checkCallback: Callable
var checkArgs: Array
var battleController: BattleController

func _init(p_controller:BattleController, p_acCallback: Callable, p_chCallback: Callable, p_AcArgs: Array = [], p_chArgs: Array = []) -> void:
	activationCallback = p_acCallback
	activationArgs = p_AcArgs
	
	checkCallback = p_chCallback
	checkArgs = p_chArgs
	
	battleController = p_controller
	
func processTurn():
	if checkCallback.call(checkArgs):
		await activationCallback.call(activationArgs)
		return true
	return false
