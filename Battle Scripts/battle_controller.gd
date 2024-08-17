extends Node

#action enums 
enum ACTION {
	ATTACK,
	DEFEND,
	CARD
}
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
@export var cardButton: Button

#maximum number of monster than can be on the field per side at the same time
var maxActiveMons: int = 3
#battle monsters owned by the player
var playerTeam: Array[BattleMonster] = []
#index for current active player mon
var activePlayerMon = 0
#battle monsters owned by the enemy
var enemyTeam: Array[BattleMonster] = []
#index for current active enemy mon
var activeEnemyMon = 0
#timer for waiting
var timer
#check if in turn
var inTurn = false
#player's chosen (cached) action
var playerAction: ACTION
#enemy's chosen action
var enemyAction: ACTION

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
		var newBattleMon = BattleMonster.new(plrTeam[index])
		#add to player team
		playerTeam.push_back(newBattleMon)
	
	#create monsters on the enemy's side
	for index in len(enmTeam):
		#create battle monster object
		var newBattleMon = BattleMonster.new(enmTeam[index])
		#add to enemy team
		enemyTeam.push_back(newBattleMon)
	
	
	
	for idIndex in min(maxActiveMons, len(playerTeam)):
		#create battle object for player
		playerMonsterObj = createMonster(true, playerTeam[activePlayerMon + idIndex].rawData, idIndex)
		#create battle object for enemy
		enemyMonsterObj = createMonster(false, enemyTeam[activeEnemyMon + idIndex].rawData, idIndex)
	
		#assign ui to player mon
		playerUI[idIndex].setConnectedMon(playerTeam[activePlayerMon+idIndex])
		#assign ui to enemy mon
		enemyUI[idIndex].setConnectedMon(enemyTeam[activeEnemyMon+idIndex])

#damage formula for basic attack
static func damageAttack(attacker: BattleMonster, defender: BattleMonster):
	return attacker.shield

func actionAttack(attacker: BattleMonster, defender: BattleMonster) -> void:
	var dmg = damageAttack(attacker, defender)
	defender.receiveDamage(dmg, attacker)

func enemyDeclare() -> void:
	#wait 1 second
	await get_tree().create_timer(1.0).timeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#debug initialization
	initialize(debugTeamA, debugTeamB)
	pass # Replace with function body.

func activeTurn() -> void:
	inTurn = true
	playerAction = 0
	#hide player gui
	playerChoiceUI.hide()
	#wait for enemy choice and animations
	await enemyDeclare()
	#show player gui
	playerChoiceUI.show()
	#wait for a gui choice to be made
	await gui_choice
	
	#run choices for player and enemy
	print("Chosen: ",playerAction)
	if playerAction == ACTION.ATTACK:
		actionAttack(playerTeam[activePlayerMon], enemyTeam[activeEnemyMon])
	
	await get_tree().create_timer(1.0).timeout
	inTurn = false

func emitGUISignal() -> void:
	gui_choice.emit()
	
func onAttackPressed() -> void:
	playerAction = ACTION.ATTACK

func onDefendPressed() -> void:
	playerAction = ACTION.DEFEND

func onCardPressed() -> void:
	playerAction = ACTION.CARD

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if no turn is started, start the next turn
	if !inTurn:
		activeTurn()
	pass
