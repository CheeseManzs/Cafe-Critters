class_name FutureAction


var callback: Callable
var args: Array
var turnsUntilActivation: int = 0
var battleController: BattleController

func _init(p_controller:BattleController, p_callback: Callable, p_turns: int, p_args: Array = []) -> void:
	callback = p_callback
	args = p_args
	battleController = p_controller
	
func processTurn():
	turnsUntilActivation -= 1
	if turnsUntilActivation <= 0:
		await callback.call(args)
		return true
	return false
