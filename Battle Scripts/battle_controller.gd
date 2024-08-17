class_name BattleController
extends Node

#signal for gui choice
signal gui_choice

#monster object prefab
@export var monsterObject: PackedScene
#current turn, 0 is player, 1 is enemy
@export var currentTurn: int
#node that corrosponds to the player monster
var playerMonsterObj: Node3D
#node that corrosponds to the enemy monster
var enemyMonsterObj: Node3D

@export var debugTeamA: Array
@export var debugTeamB: Array

#UIs for active player monsters
@export var playerUI: Array[Node]
#UIs for active enemy monsters
@export var enemyUI: Array[Node]
#UI for choosing player actions
@export var playerChoiceUI: Control
#action buttons
@export var attackButton: Button
@export var defendButton: Button
@export var cardButtons: Array[Button]

#maximum number of monster than can be on the field per side at the same time
var maxActiveMons: int = 1
#battle monsters owned by the player
var playerTeam: Array[BattleMonster] = []
#index for current active player mon
var activePlayerMon: int = 0
#battle monsters owned by the enemy
var enemyTeam: Array[BattleMonster] = []
#index for current active enemy mon
var activeEnemyMon: int = 0
#timer for waiting
var timer
#check if in turn
var inTurn: bool = false
#player's chosen (cached) action
var playerAction: Card
var playerCardID = -1
#enemy's chosen action
var enemyAction: Card

#set MP of player
var playerMP = 3
#set MP of enemy
var enemyMP = 3

#instantiates a monster
func createMonster(isPlayer, monObj, tID) -> Node3D:
	#instantiate monster node from scene
	var newObj: Node3D = monsterObject.instantiate()
	#set the team id
	newObj.teamID = tID
	#set the raw data
	newObj.set_meta("Monster_Data",monObj)
	#set the player control bool
	newObj.set_meta("playerControlled", isPlayer)
	#add monster node to scene
	add_child(newObj)
	return newObj

func initialize(plrTeam: Array, enmTeam: Array) -> void:
	#create monsters on the player's side
	for index in len(plrTeam):
		#create battle monster object
		var newBattleMon = BattleMonster.new(plrTeam[index], self, true)
		#add to player team
		playerTeam.push_back(newBattleMon)
	#set mp values
		playerMP = 3
		enemyMP = 3
	
	#create monsters on the enemy's side
	for index in len(enmTeam):
		#create battle monster object
		var newBattleMon = BattleMonster.new(enmTeam[index], self, false)
		#add to enemy team
		enemyTeam.push_back(newBattleMon)
	
	
	
	for idIndex in len(playerTeam):
		#create battle object for player
		playerMonsterObj = createMonster(true, playerTeam[activePlayerMon + idIndex].rawData, idIndex)
		
		
	for idIndex in len(enemyTeam):	
		#create battle object for enemy
		enemyMonsterObj = createMonster(false, enemyTeam[activeEnemyMon + idIndex].rawData, idIndex)	
		
	
	#assign ui to player mon
	playerUI[0].setConnectedMon(playerTeam[activePlayerMon])
	#assign ui to enemy mon
	enemyUI[0].setConnectedMon(enemyTeam[activeEnemyMon])



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#debug initialization
	initialize(debugTeamA, debugTeamB)
	pass # Replace with function body.

func enemyDeclare() -> Array[BattleAction]:
	#initialize list of possible actions
	var actions: Array[BattleAction] = []
	#loop through active mons (currently only supports 1 active mon so it doesnt really matter)
	for i in maxActiveMons:
		var mon: BattleMonster = enemyTeam[activeEnemyMon + i]
		if len(mon.currentHand.storedCards) == 0:
			BattleLog.singleton.log(mon.rawData.name + " has an empty hand!")
			continue
		#target is automatically set to the main active mon
		var chosenTarget = playerTeam[activePlayerMon]
		var chosenCard: Card = mon.currentHand.bulkDraw(1)[0]
		#add chosen card logic here
		
		#add to action queue
		var battleAction: BattleAction = BattleAction.new(
			mon,
			false,
			chosenCard.priority,
			chosenTarget,
			chosenCard
		)
		actions.push_back(battleAction)
	
	return actions
	#await get_tree().create_timer(1.0).timeout

func activeTurn() -> void:
	inTurn = true
	
	if playerMP > 6:
		playerMP = 6
	if enemyMP > 6:
		enemyMP = 6
	
	#reset temporary values
	playerTeam[activePlayerMon].reset()
	enemyTeam[activeEnemyMon].reset()
	 
	
	playerAction = null
	playerCardID = -1
	#hide player gui
	playerChoiceUI.hide()
	#wait for enemy choice and animations
	var enemyActions = enemyDeclare()

	
	var actions: Array[BattleAction] = []
	for i in maxActiveMons:
		#show player gui
		playerChoiceUI.show()
		var mon: BattleMonster = playerTeam[activePlayerMon + i]
		
		for uiIndex in len(cardButtons):
			var cardButton: Button = cardButtons[uiIndex]
			if uiIndex >= len(mon.currentHand.storedCards):
				cardButton.hide()
			else:
				cardButton.show()
				cardButton.text = mon.currentHand.storedCards[uiIndex].name
		
		#wait for a gui choice to be made
		await gui_choice
		playerChoiceUI.hide()
		await get_tree().create_timer(0.01).timeout
		#run choices for player and enemy
		var chosenTarget = enemyTeam[activeEnemyMon]
		var chosenPriority = 0
		print(playerCardID)
		var chosenCard: Card = mon.currentHand.pullCard(playerCardID)
		
		#add to action queue
		var battleAction: BattleAction = BattleAction.new(
			mon,
			true,
			chosenPriority,
			chosenTarget,
			chosenCard
		)
		actions.push_back(battleAction)
		
		#wait a bit for the next monster
		await get_tree().create_timer(0.3).timeout
	
	actions += enemyActions
	var turnSequence = BattleSequence.new(actions)
	await turnSequence.runActions(self)
	inTurn = false

func emitGUISignal() -> void:
	gui_choice.emit()
	
func onAttackPressed() -> void:
	playerAction = playerTeam[activePlayerMon].currentDeck.storedCards[0]

func onDefendPressed() -> void:
	playerAction = playerTeam[activePlayerMon].currentDeck.storedCards[1]

func onCardPressed() -> void:
	playerAction = playerTeam[activePlayerMon].currentDeck.storedCards[0]

func onHand(index: int) -> void:
	print("hand index ",index)
	playerCardID = index
	print("player card:",index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if no turn is started, start the next turn
	if !inTurn:
		activeTurn()
	pass
