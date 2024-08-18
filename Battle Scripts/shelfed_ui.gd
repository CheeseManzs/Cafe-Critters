class_name ShelfUI
extends Panel
@export var hpBar: ProgressBar
@export var faceTexture: TextureRect
@export var nameText: RichTextLabel
var connectedMon: BattleMonster
@export var battleController: BattleController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reprocess() -> void:
	nameText.text = "[center]"+connectedMon.rawData.name+"[/center]"
	faceTexture.texture = connectedMon.rawData.sprite
	

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
	var withinError = abs(hpBar.value - goalValue) < reductionRate
	
	#check if connected bar is outside of acceptable range of error
	#if more then remove value
	if withinError:
		hpBar.value = goalValue
	
	if !withinError && hpBar.value > goalValue:
		hpBar.value -= reductionRate
	#if less then add value
	if !withinError && hpBar.value < goalValue:
		hpBar.value += reductionRate
	pass

func swapIn():
	battleController.playerSwap(battleController.playerTeam.find(connectedMon))
