extends Node

#monster object prefab
@export var monsterObject: PackedScene
#current turn, 0 is player, 1 is enemy
@export var currentTurn: int
#node that corrosponds to the player monster
@export var playerMonsterObj: Node3D
#node that corrosponds to the enemy monster
@export var enemyMonsterObj: Node3D

@export var debugTeamA: Array
@export var debugTeamB: Array

#battle monsters owned by the player
var playerTeam: Array[Monster] = []
var playerObjs: Array[Monster] = []
#battle monsters owned by the enemy
var enemyTeam: Array[Monster] = []
var enemyObjs: Array[Monster] = []

#instantiates a monster
func createMonster(isPlayer, monObj, tID) -> void:
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

func initialize(plrTeam: Array, enmTeam: Array) -> void:
	#create monsters on the player's side
	for index in len(plrTeam):
		createMonster(true, plrTeam[index], index)
	#create monsters on the enemy's side
	for index in len(enmTeam):
		createMonster(false, enmTeam[index], index)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#debug initialization
	initialize(debugTeamA, debugTeamB)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
