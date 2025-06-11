class_name MonsterUI
extends Panel

#connected monster object
var connectedMon: BattleMonster
#object's text label for the monster's name
@export var monsterFace: TextureRect
#object's progress bar
@export var detailContainer: Control
@export var connectedBar: TextureProgressBar
@export var shieldBar: TextureProgressBar
@export var enemy = false
@export var externalGaugeContainer: VBoxContainer
#text labels
@export var nameLabel: RichTextLabel
@export var healthLabel: RichTextLabel
@export var unflip: Array[Control]

func setConnectedMon(mon):
	connectedMon = mon

func reloadUI() -> void:
	if connectedMon == null:
		return
	monsterFace.texture = connectedMon.rawData.sprite
	nameLabel.text = connectedMon.getName() + "     [color=yellow]"+str(connectedMon.level)+"[/color]"
	

func flipXTotal():
	self.scale = Vector2(-1, 1)
	for node in unflip:	
		print("flipping " + node.name)
		node.scale = Vector2(-1, 1)
		node.position.x += node.size.x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reloadUI()
	pass # Replace with function body.

func goalInterpolation(bar: TextureProgressBar, goalValue: float, delta: float):
	#rate at which the hp bar decreases
	var reductionRate = delta*100
	#check for acceptable error
	#print(abs(connectedBar.value - goalValue), " : ",reductionRate)
	var withinError = abs(bar.value - goalValue) < reductionRate
	
	#check if connected bar is outside of acceptable range of error
	#if more then remove value
	if withinError:
		bar.value = goalValue
	
	if !withinError && bar.value > goalValue:
		bar.value -= reductionRate
	#if less then add value
	if !withinError && bar.value < goalValue:
		bar.value += reductionRate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if connectedMon == null:
		hide()
		return
	show()
	if enemy && self.scale.x == 1:
		flipXTotal()
		
	#target value from hp bar
	var goalValue = 100*float(connectedMon.health)/float(connectedMon.maxHP)
	var shieldGoalValue = 100*float(connectedMon.shield)/float(connectedMon.maxHP)
	if shieldBar.value == shieldGoalValue:
		goalInterpolation(connectedBar, goalValue,delta)
	goalInterpolation(shieldBar, shieldGoalValue,delta*0.75)
	
	healthLabel.text = str(int(ceil(connectedBar.value*connectedMon.maxHP/100)))+"/"+str(connectedMon.maxHP)
	if connectedMon.shield > 0:
		var shieldIntp = connectedMon.shield
		healthLabel.text += " + [color=#"+Card.tooltipColors["DEF"]+"]"+str(shieldIntp)+"[/color]"
	pass
