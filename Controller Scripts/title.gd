class_name DebugGameManager
extends Node2D

var debugTeamA: Array[Monster] = []
var debugTeamB: Array[Monster] = []
@export_multiline var enemyTeamExport: String
@export var debugPersonality: AIPersonality

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(debugPersonality)
	#debugTeamA[0].level = 8
	#debugTeamA[1].level = 8
	if LoadManager.activeScene == null:
		LoadManager.activeScene = get_tree().current_scene
	debugTeamB = ConnectionManager.singleton.teamPacker.decode(enemyTeamExport)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func loadScene(sceneName: String) -> void:
	if sceneName == "Battle":
		print("personality: ", debugPersonality)
		ConnectionManager.singleton.setTeam()
		BattleController.startBattle(ConnectionManager.playerTeam, debugTeamB, debugPersonality)
		return
	if sceneName == "DeckEditUI":
		ConnectionManager.singleton.setTeam()
	LoadManager.loadScene(sceneName)
	pass # Replace with function body.
