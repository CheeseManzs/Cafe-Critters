extends Node
@export var battleController: BattleController
@export var progressBar: ProgressBar
@export var player = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		progressBar.value 
	pass
	#target value from mp bar
	var goalValue = 100*battleController.enemyMP/6.0
	#if ui is assigned to player, use player mp value instead
	if player:
		goalValue = 100*battleController.playerMP/6.0
	else:
		progressBar.fill_mode = ProgressBar.FillMode.FILL_END_TO_BEGIN
	#rate at which the mp bar decreases
	var reductionRate = delta*100
	#check for acceptable error
	#print(abs(connectedBar.value - goalValue), " : ",reductionRate)
	var withinError = abs(progressBar.value - goalValue) < reductionRate
	
	#check if connected bar is outside of acceptable range of error
	#if more then remove value
	if withinError:
		progressBar.value = goalValue
	
	if !withinError && progressBar.value > goalValue:
		progressBar.value -= reductionRate
	#if less then add value
	if !withinError && progressBar.value < goalValue:
		progressBar.value += reductionRate
