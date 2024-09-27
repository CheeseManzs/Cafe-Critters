extends Control
## Main inventory controller. Propagates data to and creates individual inventory items.

var timer = 0
var speed = 1.5
var isOpening = false
@export var debugMonsters: Array[Monster]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateMonsters(debugMonsters)
	pass # Replace with function body.

func updateMonsters(playerMonsters):
	# resets main display to blank slate
	# Resets party display to blank slate
	for mon in $PartyContainer.get_children():
		mon.initiate(null)
	# sets the appropriate icons for each party member
	for i in playerMonsters.size():
		$PartyContainer.get_child(i).initiate(playerMonsters[i])
		
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# generic animatng code.
	if isOpening == true:
		timer += delta * speed
		if timer > 1: timer = 1
	else:
		timer -= delta * speed
		if timer < 0: timer = 0
	var processVal = 1
	#var processVal = sin(PI * timer / 2)
	anchor_top = -1 + (processVal)
	anchor_bottom = (processVal)
	pass


func _on_party_monster_1_on_click() -> void:
	if $PartyContainer/PartyMonster1.refMonster != null:
		$MainUI.initiate($PartyContainer/PartyMonster1.refMonster)
	pass # Replace with function body.


func _on_party_monster_2_on_click() -> void:
	pass # Replace with function body.
	if $PartyContainer/PartyMonster2.refMonster != null:
		$MainUI.initiate($PartyContainer/PartyMonster2.refMonster)


func _on_party_monster_3_on_click() -> void:
	if $PartyContainer/PartyMonster3.refMonster != null:
		$MainUI.initiate($PartyContainer/PartyMonster3.refMonster)
	pass # Replace with function body.


func _on_levelup_button_button_up() -> void:
	$PartyContainer.isOpening = true
	$LevelupPanel.isOpening = true
	$LevelupCosts.isOpening = true
	$MainUI/BodyPanel.isOpening = true
	pass # Replace with function body.


func _on_deck_button_button_up() -> void:
	pass # Replace with function body.
