extends Panel

#connected monster object
var connectedMon: BattleMonster
#object's text label for the monster's name
@export var connectedLabel: RichTextLabel
#object's progress bar
@export var connectedBar: ProgressBar

func setConnectedMon(mon):
	connectedMon = mon

func reloadUI() -> void:
	if connectedMon == null:
		return
	connectedLabel.text = connectedMon.rawData.name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reloadUI()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if connectedMon == null:
		hide()
		return
	show()
	#target value from hp bar
	var goalValue = 100*float(connectedMon.health)/float(connectedMon.maxHP)
	#rate at which the hp bar decreases
	var reductionRate = delta*100
	#check for acceptable error
	#print(abs(connectedBar.value - goalValue), " : ",reductionRate)
	var withinError = abs(connectedBar.value - goalValue) < reductionRate
	
	#check if connected bar is outside of acceptable range of error
	#if more then remove value
	if withinError:
		connectedBar.value = goalValue
	
	if !withinError && connectedBar.value > goalValue:
		connectedBar.value -= reductionRate
	#if less then add value
	if !withinError && connectedBar.value < goalValue:
		connectedBar.value += reductionRate
		
	pass
